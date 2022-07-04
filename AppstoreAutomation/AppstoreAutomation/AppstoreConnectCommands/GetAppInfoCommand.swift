//
//  GetAppInfoCommand.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 2/7/22.
//

import Foundation

class GetAppInfoCommand {
    private let method = Method.get
    struct Request {
        var appId: String
    }

    struct Attributes: Codable {
        var appStoreState: AppStoreVersionState
    }

    struct AppInfo: Codable {
        var attributes: Attributes?
        var id: String
        var links: DocumentLink
        var type: String = "appInfos"
    }

    struct Response: Codable {
        var data: [AppInfo]
        var links: PagedDocumentLinks
    }

    func execute(appId: String, apiAccess: APIAccess) async throws -> Response {
        let request = GetAppInfoCommand.Request(appId: appId)

        let urlString = "\(baseUrl)/apps/\(request.appId)/appInfos"
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        let response: Response = try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
        return response
    }
}
