//
//  GetAllLocalizationsCommand.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 1/7/22.
//

import Foundation

class GetAllLocalizationsCommand {
    struct AppStoreVersionLocalization: Codable {
        var attributes: CreateNewLocalizationCommand.Attributes
        var id: String
        var links: DocumentLink
    }

    struct AppStoreVersionLocalizationsResponse: Codable {
        var data: [AppStoreVersionLocalization]

        var links: DocumentLink
    }

    let method = "GET"

    struct Request {
        /// this is actually platform id of an app
        var appStoreVersionId: String
    }

    func execute(request: Request, apiAccess: APIAccess) async throws -> AppStoreVersionLocalizationsResponse {
        let urlString = "https://api.appstoreconnect.apple.com/v1/appStoreVersions/\(request.appStoreVersionId)/appStoreVersionLocalizations"
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        let response: AppStoreVersionLocalizationsResponse = try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
        return response
    }
}
