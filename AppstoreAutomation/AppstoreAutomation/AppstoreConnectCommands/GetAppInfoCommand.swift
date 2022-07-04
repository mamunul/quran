//
//  GetAppInfoCommand.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 2/7/22.
//

import Foundation
struct AppInfo: Codable {
    struct Attributes: Codable {
        var appStoreState: AppStoreVersionState
    }

    var attributes: Attributes?
    var id: String
    var links: DocumentLink
    var type: String = "appInfos"
}

class GetAppInfoCommand {
    private let method = Method.get
    struct APIRequest {
        var appId: String
    }

    struct APIResponse: Codable {
        var data: [AppInfo]
        var links: PagedDocumentLinks
    }

    private func makeURLRequest(apiRequest: APIRequest) -> URLRequest {
        let urlString = "\(baseUrl)/apps/\(apiRequest.appId)/appInfos"
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }

    func execute(appId: String, apiAccess: APIAccess) async throws -> APIResponse {
        let request = APIRequest(appId: appId)
        let urlRequest = makeURLRequest(apiRequest: request)
        let response: APIResponse = try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
        return response
    }
}
