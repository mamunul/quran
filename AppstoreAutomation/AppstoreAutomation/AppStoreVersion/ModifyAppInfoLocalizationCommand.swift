//
//  CreateAppInfoLocalization.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 2/7/22.
//

import Foundation

class ModifyAppInfoLocalizationCommand {
    let method = "PATCH"

    struct Attributes: Codable {
        var name: String
        var privacyPolicyText: String?
        var privacyPolicyUrl: String?
        var subtitle: String?
        var privacyChoicesUrl: String?
    }

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
        var attributes: Attributes
        var id: String
        var type: String = "appInfoLocalizations"
    }

    struct Request: Codable {
        var data: RequestData
    }

    struct AppInfoLocalization: Codable {
        var type: String
        var id: String
        var links: DocumentLink
        var attributes: Attributes
    }

    struct Response: Codable {
        var data: AppInfoLocalization
        var links: DocumentLink
        var included: [AppInfo]?
    }

    func execute(request: Request, apiAccess: APIAccess) async throws -> Response {
        let urlString = "https://api.appstoreconnect.apple.com/v1/appInfoLocalizations/\(request.data.id)"
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method
        urlRequest.httpBody = try JSONEncoder().encode(request)
        let response: Response = try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
        return response
    }
}
