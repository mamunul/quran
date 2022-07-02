//
//  CreateAppInfoLocalization.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 2/7/22.
//

import Foundation

struct AppInfoLocalizationsResponse: Codable {
    var data: [AppInfoLocalization]
    var links: PagedDocumentLinks
    var included: [CreateAppInfoLocalizationCommand.AppInfo]?
}

class GetAppInfoLocalizationsCommand {
    private let method = Method.get

    struct Request: Codable {
        var appInfoId: String
    }

    func execute(request: Request, apiAccess: APIAccess) async throws -> AppInfoLocalizationsResponse {
        let urlString = "https://api.appstoreconnect.apple.com/v1/appInfos/\(request.appInfoId)/appInfoLocalizations"
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        let response: AppInfoLocalizationsResponse = try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
        return response
    }
}
