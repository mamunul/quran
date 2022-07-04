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

    struct Request {
        var appScreenshotsId: String
    }
    private let method = Method.delete
    func execute(request: Request, apiAccess: APIAccess) async throws {
        let urlString = "\(baseUrl)/appScreenshotSets/\(request.appScreenshotsId)"
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
    }
}
