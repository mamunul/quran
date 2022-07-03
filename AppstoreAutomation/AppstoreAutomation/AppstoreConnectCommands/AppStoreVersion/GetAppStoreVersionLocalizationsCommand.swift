//
//  GetAllLocalizationsCommand.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 1/7/22.
//

import Foundation

struct AppStoreVersionLocalization: Codable {
    var attributes: AppStoreVersionLocalizationAttributes
    var id: String
    var links: DocumentLink
}

struct AppStoreVersionLocalizationsResponse: Codable {
    var data: [AppStoreVersionLocalization]

    var links: DocumentLink
}

class GetAppStoreVersionLocalizationsCommand {
    private let method = Method.get

    struct Request {
        /// this is actually platform id of an app
        var appStoreVersionId: String
    }

    func execute(request: Request, apiAccess: APIAccess) async throws -> AppStoreVersionLocalizationsResponse {
        let urlString = "\(baseUrl)appStoreVersions/\(request.appStoreVersionId)/appStoreVersionLocalizations"
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        let response: AppStoreVersionLocalizationsResponse = try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
        return response
    }
}
