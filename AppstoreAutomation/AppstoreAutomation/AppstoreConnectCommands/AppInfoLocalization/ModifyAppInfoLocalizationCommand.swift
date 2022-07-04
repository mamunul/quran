//
//  CreateAppInfoLocalization.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 2/7/22.
//

import Foundation

struct AppInfoLocalization: Codable {
    var type: String
    var id: String
    var links: DocumentLink
    var attributes: AppInfoLocalizationAttributes
}

struct AppInfoLocalizationResponse: Codable {
    var data: AppInfoLocalization
    var links: DocumentLink
    var included: [ModifyAppInfoLocalizationCommand.AppInfo]?
}

class ModifyAppInfoLocalizationCommand {
    private let method = Method.patch

    struct AppInfoData: Codable {
        /// appInfo Id
        var id: String
        var type: String = "appInfos"
    }

    struct AppInfo: Codable {
        var data: AppInfoData
    }

    struct Relationships: Codable {
        var appInfo: AppInfo
    }

    struct RequestData: Codable {
        var attributes: AppInfoLocalizationAttributes
        var id: String
        var type: String = "appInfoLocalizations"
    }

    struct Request: Codable {
        var data: RequestData
    }

    func execute(appInfoLocalizationId: String, attributes: AppInfoLocalizationAttributes, apiAccess: APIAccess) async throws -> AppInfoLocalizationResponse {
        let requestData = RequestData(attributes: attributes, id: appInfoLocalizationId)
        let request = Request(data: requestData)

        let urlString = "\(baseUrl)appInfoLocalizations/\(request.data.id)"
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = try JSONEncoder().encode(request)
        let response: AppInfoLocalizationResponse = try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
        return response
    }
}
