//
//  CreateAppInfoLocalization.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 2/7/22.
//

import Foundation

class GetAppInfoLocalizationsCommand {
    let method = "GET"

    struct Request: Codable {
        var appInfoId: String
    }

    struct Response: Codable {
        var data: [CreateAppInfoLocalizationCommand.AppInfoLocalization]
        var links: PagedDocumentLinks
        var included: [CreateAppInfoLocalizationCommand.AppInfo]?
    }

    func execute(request: Request, apiAccess: APIAccess) async throws -> Response {
        let urlString = "https://api.appstoreconnect.apple.com/v1/appInfos/\(request.appInfoId)/appInfoLocalizations"
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        let response: Response = try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
        return response
    }
}
