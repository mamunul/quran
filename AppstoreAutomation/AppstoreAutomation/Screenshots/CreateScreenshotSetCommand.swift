//
//  Screenshots.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 30/6/22.
//

import Foundation

class CreateScreenshotSetCommand {
    struct RequestData {
        var attributes: GetScreenshotSetCommand.Attributes
        var type: String
    }

    struct AppScreenshotSetRequest {
        var data: RequestData
    }

    let method = "POST"
    func execute(request: AppScreenshotSetRequest, apiAccess: APIAccess) async throws -> GetScreenshotSetCommand.AppScreenshotSetResponse {
        let urlString = "https://api.appstoreconnect.apple.com/v1/appScreenshotSets"
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        let response: GetScreenshotSetCommand.AppScreenshotSetResponse = try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
        return response
    }
}

struct PagedDocumentLinks: Codable {
    var first: String
    var next: String
    var `self`: String
}
