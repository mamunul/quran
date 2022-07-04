//
//  CreateNewLocalizationCommand.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 1/7/22.
//

import Foundation

class ModifyAppStoreVersionLocalizationCommand {
    private let method = Method.patch

    struct RelationshipData: Codable {
        var type: String = "appStoreVersions"
        var id: String
    }

    struct AppStoreVersion: Codable {
        var data: RelationshipData
    }

    struct Relationships: Codable {
        var appStoreVersion: AppStoreVersion
    }

    struct RequestData: Codable {
        var type: String = "appStoreVersionLocalizations"
        var attributes: AppStoreVersionLocalizationAttributes
        var id: String
    }

    struct LocalizationRequest: Codable {
        var data: RequestData
    }

    func execute(appStoreVersionLocalizaitonId: String, attributes: AppStoreVersionLocalizationAttributes, apiAccess: APIAccess)
    async throws -> AppStoreVersionLocalizationResponse {
        let data = RequestData(attributes: attributes, id: appStoreVersionLocalizaitonId)
        let request = LocalizationRequest(data: data)

        let urlString = "\(baseUrl)/appStoreVersionLocalizations/\(request.data.id)"
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = try JSONEncoder().encode(request)
        let response: AppStoreVersionLocalizationResponse =
            try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
        return response
    }
}
