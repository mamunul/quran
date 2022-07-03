//
//  GetALocalizationCommand.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 1/7/22.
//

import Foundation

struct AppStoreVersionLocalizationResponse: Codable {
    var data: AppStoreVersionLocalization
    var included: String // AppStoreVersion, AppScreenshotSet, AppPreviewSet
    var links: DocumentLink
}

class GetAppStoreVersionLocalizationCommand {
    private let method = Method.get

    struct Request {
        var appStoreVersionLocalizationId: String
    }

    func execute(request: Request, apiAccess: APIAccess) async throws -> AppStoreVersionLocalizationResponse {
        let urlString = "\(baseUrl)appStoreVersionLocalizations/\(request.appStoreVersionLocalizationId)"
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        let response: AppStoreVersionLocalizationResponse = try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
        return response
    }
}
