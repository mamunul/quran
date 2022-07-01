//
//  DeleteALocalizationCommand.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 1/7/22.
//

import Foundation

class DeleteALocalizationCommand {
    struct Request {
        var appStoreVersionLocalizationId: String
    }

    let method = "DELETE"
    func execute(request: Request, apiAccess: APIAccess) async throws {
        let urlString = "https://api.appstoreconnect.apple.com/v1/appStoreVersions/\(request.appStoreVersionLocalizationId)/appStoreVersionLocalizations"
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
    }
}
