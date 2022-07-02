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

    struct Attributes: Codable {
        private(set) var keywords: String
        private(set) var description: String
        private(set) var marketingUrl: String
        private(set) var promotionalText: String?
        private(set) var supportUrl: String
        private(set) var whatsNew: String?

        init(
            keywords: String,
            description: String,
            marketingUrl: String,
            promotionalText: String? = nil,
            supportUrl: String,
            whatsNew: String? = nil
        ) throws {
            self.keywords = keywords
            self.description = description
            self.marketingUrl = marketingUrl
            self.promotionalText = promotionalText
            self.supportUrl = supportUrl
            self.whatsNew = whatsNew

            if description.count < 10 { throw ValidaitonError.invalidProperty("description") }
        }
    }

    struct Relationships: Codable {
        var appStoreVersion: AppStoreVersion
    }

    struct RequestData: Codable {
        var type: String = "appStoreVersionLocalizations"
        var attributes: Attributes
        var id: String
    }

    struct LocalizationRequest: Codable {
        var data: RequestData
    }

    struct ResponseData: Codable {
        var type: String
        var attributes: Attributes
        var id: String
    }

    struct LocalizationResponse: Codable {
        var data: ResponseData
    }

    func execute(request: LocalizationRequest, apiAccess: APIAccess) async throws -> LocalizationResponse {
        let urlString = "https://api.appstoreconnect.apple.com/v1/appStoreVersionLocalizations/\(request.data.id)"
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = try JSONEncoder().encode(request)
        let response: LocalizationResponse = try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
        return response
    }
}
