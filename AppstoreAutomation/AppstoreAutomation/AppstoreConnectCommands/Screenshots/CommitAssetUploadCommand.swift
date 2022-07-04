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

    private let method = Method.patch
    func execute(request: UploadCommitRequest, access: APIAccess) async throws {
        let urlString = "\(baseUrl)/appScreenshots/\(request.data.id)"
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(request)
        try await HTTPHandler().execute(urlRequest: urlRequest, access: access)
    }
}
