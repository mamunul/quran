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
        let displayType: ScreenshotDisplayType
        let locale: String
    }

    private func makeAnUploadRequest(request: RequestUploadCommand.ScreenshotRequest, apiAccess: APIAccess)
    async throws -> RequestUploadCommand.ScreenshotResponse {
        let response = try await RequestUploadCommand().execute(request: request, apiAccess: apiAccess)
        return response
    }

    private func uploadTheAsset(uploads: [GetScreenshotCommand.UploadOperation], assetData: Data) {
        Task {
            for upload in uploads {
                let subData = assetData.subdata(in: upload.offset ..< upload.length + upload.offset + 1)

                let url = URL(string: upload.url)!
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = upload.method
                urlRequest.httpBody = subData
                do {
                    try await HTTPHandler().execute(urlRequest: urlRequest)
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
        try await CommitAssetUploadCommand().execute(request: request)
    }

    private func verifyUpload() {
        
//        GetScre
    }

    func upload(request: RequestUploadCommand.ScreenshotRequest, apiAccess: APIAccess, screenshot: Screenshot) async throws {
        Task {
            do {
                let response = try await self.makeAnUploadRequest(request: request, apiAccess: apiAccess)

                let data = try Data(contentsOf: screenshot.url)
                let reservationId = response.data.id
                let md5Checksum = Insecure.MD5.hash(data: data).map { String(format: "%02hhx", $0) }.joined()
                uploadTheAsset(uploads: response.data.attributes.uploadOperations ?? [], assetData: data)
                try await commitTheUpload(reservationId: reservationId, checksum: md5Checksum)
                verifyUpload()
            } catch {
                print(error)
            }
        }
    }
}
