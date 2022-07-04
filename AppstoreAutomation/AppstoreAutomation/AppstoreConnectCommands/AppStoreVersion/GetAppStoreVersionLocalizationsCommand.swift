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

    struct APIRequest {
        /// this is actually platform id of an app
        var appStoreVersionId: String
    }

    private func makeUrlRequest(apiRequest: APIRequest) -> URLRequest {
        let urlString = "\(baseUrl)/appStoreVersions/\(apiRequest.appStoreVersionId)/appStoreVersionLocalizations"
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }

    func execute(appStoreVersionId: String, apiAccess: APIAccess) async throws ->
        AppStoreVersionLocalizationsResponse {
        let request = APIRequest(appStoreVersionId: appStoreVersionId)
        let urlRequest = makeUrlRequest(apiRequest: request)
        let response: AppStoreVersionLocalizationsResponse =
            try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
        return response
    }
}
