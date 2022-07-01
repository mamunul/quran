//
//  CreateNewLocalizationCommand.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 1/7/22.
//

import Foundation

class CreateNewLocalizationCommand {
    let method = "POST"
    let urlString = "https://api.appstoreconnect.apple.com/v1/appStoreVersionLocalizations"

    struct RelationshipData {
        var type: String
        var id: String
    }

    struct Attributes: Codable {
        var locale: String
        var description: String
        var keywords: String?
        var marketingUrl: String
        var promotionalText: String?
        var supportUrl: String
        var whatsNew: String?
    }

    struct Relationships {
        var appStoreVersion: RelationshipData
    }

    struct RequestData {
        var type: String
        var attributes: Attributes
        var relationships: Relationships
    }

    struct LocalizationRequest {
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
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        let response: LocalizationResponse = try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
        return response
    }
}
