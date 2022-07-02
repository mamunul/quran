//
//  ScreenshotSetDeleteCommand.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 1/7/22.
//

import Foundation

class DeleteScreenshotSetCommand {
    /*
     DELETE https://api.appstoreconnect.apple.com/v1/appScreenshotSets/{id}
     */

    struct Request {
        var appScreenshotsId: String
    }
    private let method = Method.delete
    func execute(request: Request, apiAccess: APIAccess) async throws {
        let urlString = "https://api.appstoreconnect.apple.com/v1/appScreenshotSets/\(request.appScreenshotsId)"
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
    }
}
