//
//  RequestUploadCommand.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 1/7/22.
//

import Foundation

class RequestUploadCommand {
//    POST https://api.appstoreconnect.apple.com/v1/appScreenshots
    struct AppScreenshotSetData {
        var id: String
        var type: String = "appScreenshots"
    }

    struct AppScreenshotSet {
        var data: AppScreenshotSetData
    }

    struct Relationships {
        var appScreenshotSet: AppScreenshotSet
    }

    struct RequestAttributes {
        var fileName: String
        var fileSize: Int
    }

    struct RequestData {
        var attributes: RequestAttributes
        var relationships: Relationships
        var type: String = "appScreenshots"
    }

    struct ScreenshotRequest {
        var data: RequestData
    }

    struct ScreenshotResponse:Codable {
        var links: DocumentLink
        var data: ScreenshotGetCommand.AppScreenshot
    }

    let method = "POST"
    func execute(request: ScreenshotRequest, apiAccess: APIAccess) async throws -> ScreenshotResponse {
        let urlString = "https://api.appstoreconnect.apple.com/v1/appScreenshots"
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        let response: ScreenshotResponse = try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
        return response
    }
}
