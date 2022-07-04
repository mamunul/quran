//
//  ScreenshotSetDeleteCommand.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 1/7/22.
//

import Foundation

class DeleteScreenshotSetCommand {
    /*
     DELETE \(baseUrl)/appScreenshotSets/{id}
     */

    struct APIRequest {
        var appScreenshotsId: String
    }

    private let method = Method.delete

    private func makeURLRequest(apiRequest: APIRequest) -> URLRequest {
        let urlString = "\(baseUrl)/appScreenshotSets/\(apiRequest.appScreenshotsId)"
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }

    func execute(request: APIRequest, apiAccess: APIAccess) async throws {
        let urlRequest = makeURLRequest(apiRequest: request)
        try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
    }
}
