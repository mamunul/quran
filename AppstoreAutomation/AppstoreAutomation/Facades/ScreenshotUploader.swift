//
//  ScreenshotUploader.swift
//  AppstoreAutomation
//
//  Created by newone on 30/6/22.
//

import CryptoKit
import Foundation

protocol IUploadable {
    func makeAnUploadRequest(request: RequestUploadCommand.ScreenshotRequest, apiAccess: APIAccess)
    func uploadTheAsset()
    func commitTheUpload()
    func verifyUpload()
}

extension IUploadable { // Template Method
    func upload(request: RequestUploadCommand.ScreenshotRequest, apiAccess: APIAccess) {
        makeAnUploadRequest(request: request, apiAccess: apiAccess)
        uploadTheAsset()
        commitTheUpload()
        verifyUpload()
    }
}

class ScreenshotUploader {
    struct Screenshot {
        let url: URL
        let displayType: DisplayType
        let locale: Localization
    }

    private var apiAccess: APIAccess?

    private func makeAnUploadRequest(_ appScreenshotSetId: String, _ fileName: String, _ fileSize: Int) async throws ->
        RequestUploadCommand.ScreenshotResponse {
        let screenshotSetData = RequestUploadCommand.AppScreenshotSetData(id: appScreenshotSetId)
        let screenshotSet = RequestUploadCommand.AppScreenshotSet(data: screenshotSetData)
        let relationships = RequestUploadCommand.Relationships(appScreenshotSet: screenshotSet)
        let attributes = RequestUploadCommand.RequestAttributes(fileName: fileName, fileSize: fileSize)
        let requestData = RequestUploadCommand.RequestData(attributes: attributes, relationships: relationships)
        let request = RequestUploadCommand.ScreenshotRequest(data: requestData)

        let response = try await RequestUploadCommand().execute(request: request, apiAccess: apiAccess!)
        return response
    }

    private func deleteReservationIfUploadFailed(reservationId: String) async throws {
        let request = DeleteAppScreenshotsCommand.APIRequest(appScreenshotId: reservationId)
        try await DeleteAppScreenshotsCommand().execute(request: request, apiAccess: apiAccess!)
    }

    private func uploadTheAsset(response: RequestUploadCommand.ScreenshotResponse, assetData: Data) async throws {
        let uploads = response.data.attributes.uploadOperations ?? []
        for upload in uploads {
            let subData = assetData.subdata(in: upload.offset ..< upload.length + upload.offset)

            let url = URL(string: upload.url)!
            var urlRequest = URLRequest(url: url)

            upload.requestHeaders.forEach { header in
                urlRequest.setValue(header.value, forHTTPHeaderField: header.name)
            }

            urlRequest.httpMethod = upload.method
            urlRequest.httpBody = subData

            do {
                try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess!)
            } catch {
                print(error)

                do {
                    try await deleteReservationIfUploadFailed(reservationId: response.data.id)
                } catch {
                    print(error)
                }
            }
        }
    }

    private func commitTheUpload(reservationId: String, checksum: String) async throws {
        let attributes = CommitAssetUploadCommand.RequestDataAttributes(uploaded: true, sourceFileChecksum: checksum)
        let data = CommitAssetUploadCommand.RequestData(id: reservationId, attributes: attributes)
        let request = CommitAssetUploadCommand.UploadCommitRequest(data: data)
        try await CommitAssetUploadCommand().execute(request: request, access: apiAccess!)
    }

    private func verifyUpload() {
//        GetScre
    }

    func upload(appScreenshotSetId: String, apiAccess: APIAccess, screenshot: Screenshot) async throws{
        self.apiAccess = apiAccess

        let data = try Data(contentsOf: screenshot.url)
        let fileName = screenshot.url.lastPathComponent

        let response = try await makeAnUploadRequest(appScreenshotSetId, fileName, data.count)

        let md5Checksum = Insecure.MD5.hash(data: data).map { String(format: "%02hhx", $0) }.joined()
        try await uploadTheAsset(response: response, assetData: data)
        try await commitTheUpload(reservationId: response.data.id, checksum: md5Checksum)
        verifyUpload()
    }
}
