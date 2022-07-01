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

    struct RequestData {
        var attributes: Attributes
        var type: String
    }

    struct AppScreenshotSetRequest {
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
        let response: AppScreenshotSetResponse = try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
        return response
    }
}

struct PagedDocumentLinks: Codable {
    var first: String?
    var next: String?
    var `self`: String
}
