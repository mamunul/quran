//
//  ScreenshotSetDeleteCommand.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 1/7/22.
//

import Foundation

class DeleteAppScreenshotsCommand {
    struct APIRequest {
        var appScreenshotId: String
    }

    private let method = Method.delete
    func execute(request: APIRequest, apiAccess: APIAccess) async throws {
        let urlString = "\(baseUrl)/appScreenshots/\(request.appScreenshotId)"
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
    }
}
