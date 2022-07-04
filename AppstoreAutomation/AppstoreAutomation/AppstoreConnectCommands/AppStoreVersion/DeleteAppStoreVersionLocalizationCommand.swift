//
//  DeleteALocalizationCommand.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 1/7/22.
//

import Foundation

class DeleteAppStoreVersionLocalizationCommand {
    private let apiAccess: APIAccess

    init(apiAccess: APIAccess) {
        self.apiAccess = apiAccess
    }

    private func makeURLRequest(appStoreVersionLocalizationId: String) -> URLRequest {
        let urlString = "\(baseUrl)/appStoreVersions/\(appStoreVersionLocalizationId)/appStoreVersionLocalizations"
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }

    private let method = Method.delete
    func execute(appStoreVersionLocalizationId: String, apiAccess: APIAccess) async throws {
        let urlRequest = makeURLRequest(appStoreVersionLocalizationId: appStoreVersionLocalizationId)
        try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
    }
}
