//
//  CommitAssetUploadCommand.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 1/7/22.
//

import Foundation

class CommitAssetUploadCommand {
    /*
     PATCH /v1/appScreenshots/4d62262c-4ec1-4d89-b82c-c7b7a402e866
     */

    struct RequestDataAttributes: Codable {
        var uploaded: Bool
        var sourceFileChecksum: String
    }

    struct RequestData: Codable {
        var type = "appScreenshots"
        var id: String
        var attributes: RequestDataAttributes
    }

    struct UploadCommitRequest: Codable {
        var data: RequestData
    }

    let method = "PATCH"
    func execute(request: UploadCommitRequest) async throws {
        let urlString = "https://api.appstoreconnect.apple.com/v1/appScreenshots/\(request.data.id)"
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.httpBody = try JSONEncoder().encode(request)
        try await HTTPHandler().execute(urlRequest: urlRequest)
    }
}
