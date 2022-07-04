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

    func execute(appInfoId: String, apiAccess: APIAccess) async throws -> AppInfoLocalizationsResponse {
        let request = Request(appInfoId: appInfoId)

        let urlString = "\(baseUrl)appInfos/\(request.appInfoId)/appInfoLocalizations"
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        let response: AppInfoLocalizationsResponse = try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
        return response
    }
}
