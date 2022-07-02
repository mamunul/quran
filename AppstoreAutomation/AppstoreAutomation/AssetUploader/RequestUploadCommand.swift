//
//  RequestUploadCommand.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 1/7/22.
//

import Foundation

class RequestUploadCommand {
//    POST https://api.appstoreconnect.apple.com/v1/appScreenshots
    struct AppScreenshotSetData: Codable {
        var id: String
        var type: String = "appScreenshotSets"
    }

    struct AppScreenshotSet: Codable {
        var data: AppScreenshotSetData
    }

    struct Relationships: Codable {
        var appScreenshotSet: AppScreenshotSet
    }

    struct RequestAttributes: Codable {
        var fileName: String
        var fileSize: Int
    }

    struct RequestData: Codable {
        var attributes: RequestAttributes
        var relationships: Relationships
        var type: String = "appScreenshots"
    }

    struct ScreenshotRequest: Codable {
        var data: RequestData
    }

    struct ScreenshotResponse: Codable {
        var links: DocumentLink
        var data: GetScreenshotCommand.AppScreenshot
    }

    private let method = Method.post
    func execute(request: ScreenshotRequest, apiAccess: APIAccess) async throws -> ScreenshotResponse {
        let urlString = "https://api.appstoreconnect.apple.com/v1/appScreenshots"
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(request)
        let response: ScreenshotResponse = try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
        return response
    }
}
