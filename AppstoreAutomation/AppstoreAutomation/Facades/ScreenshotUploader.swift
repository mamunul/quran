//
//  ScreenshotUploader.swift
//  AppstoreAutomation
//
//  Created by newone on 30/6/22.
//

import CryptoKit
import Foundation

struct Screenshot {
    let url: URL
    let displayType: DisplayType
    let locale: Localization
}

class ScreenshotUploader {
    enum UploadError: Error {
        case uploadFailed
    }

    private var apiAccess: APIAccess?
    private func makeAnUploadRequest(_ appScreenshotSetId: String, _ fileName: String, _ fileSize: Int) async throws ->
        AppScreenshot {
        let response =
            try await RequestUploadCommand().execute(
                appScreenshotSetId: appScreenshotSetId,
                fileName: fileName,
                fileSize: fileSize,
                apiAccess: apiAccess!
            )
        return response.data
    }

    private func deleteReservationIfUploadFailed(reservationId: String) async {
        do {
            try await DeleteAppScreenshotsCommand().execute(appScreenshotId: reservationId, apiAccess: apiAccess!)
        } catch {
            print(error)
        }
    }

    private func uploadTheAsset(response: AppScreenshot, assetData: Data) async throws {
        let uploads = response.attributes.uploadOperations ?? []
        for upload in uploads {
            let subData = assetData.subdata(in: upload.offset ..< upload.length + upload.offset)
            do {
                try await DataUploadCommand().execute(upload: upload, data: subData, apiAccess: apiAccess!)
            } catch {
                print(error)
                await deleteReservationIfUploadFailed(reservationId: response.id)
                throw UploadError.uploadFailed
            }
        }
    }

    private func commitTheUpload(reservationId: String, checksum: String) async throws {
        try await CommitAssetUploadCommand().execute(
            reservationId: reservationId,
            sourceFileChecksum: checksum,
            access: apiAccess!
        )
    }

    private func verifyUpload() {
//        GetScre
    }

    func upload(appScreenshotSetId: String, apiAccess: APIAccess, screenshot: Screenshot) async throws {
        self.apiAccess = apiAccess

        let data = try Data(contentsOf: screenshot.url)
        let fileName = screenshot.url.lastPathComponent

        let response = try await makeAnUploadRequest(appScreenshotSetId, fileName, data.count)

        let md5Checksum = Insecure.MD5.hash(data: data).map { String(format: "%02hhx", $0) }.joined()
        try await uploadTheAsset(response: response, assetData: data)
        try await commitTheUpload(reservationId: response.id, checksum: md5Checksum)
        verifyUpload()
    }
}
