//
//  Screenshots.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 30/6/22.
//

import Foundation

class CreateScreenshotSetCommand {
    struct Attributes: Codable {
        var screenshotDisplayType: ScreenshotDisplayType
    }

    struct AppStoreVersionLocalizationData: Codable {
        var id: String
        var type = "appStoreVersionLocalizations"
    }

    struct AppStoreVersionLocalization: Codable {
        var data: AppStoreVersionLocalizationData
    }

    struct Relationships: Codable {
        var appStoreVersionLocalization: AppStoreVersionLocalization
    }

    struct RequestData: Codable {
        var attributes: Attributes
        var type: String = "appScreenshotSets"
        var relationships: Relationships
    }

    struct AppScreenshotSetRequest: Codable {
        var data: RequestData
    }

    struct AppScreenshotSet: Codable {
        var attributes: Attributes
        var id: String

        var links: DocumentLink

        var type: String
    }

    struct AppScreenshotSetResponse: Codable {
        var data: AppScreenshotSet
        var links: DocumentLink
    }

    let method = "POST"
    func execute(request: AppScreenshotSetRequest, apiAccess: APIAccess) async throws -> AppScreenshotSetResponse {
        let urlString = "https://api.appstoreconnect.apple.com/v1/appScreenshotSets"
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.httpBody = try JSONEncoder().encode(request)
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let response: AppScreenshotSetResponse = try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
        return response
    }
}

struct PagedDocumentLinks: Codable {
    var first: String?
    var next: String?
    var `self`: String
}
