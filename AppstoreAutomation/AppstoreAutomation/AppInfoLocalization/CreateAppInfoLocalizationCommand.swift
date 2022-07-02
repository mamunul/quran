//
//  CreateAppInfoLocalization.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 2/7/22.
//

import Foundation

struct AppInfoLocalizationAttributes: Codable {
    var locale: Localization
    var name: String
    var privacyPolicyText: String?
    var privacyPolicyUrl: String?
    var subtitle: String?
    var privacyChoicesUrl: String?
}

class CreateAppInfoLocalizationCommand {
    private let method = Method.post
    let urlString = "https://api.appstoreconnect.apple.com/v1/appInfoLocalizations"



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

        var relationships: Relationships

        var type: String = "appInfoLocalizations"
    }

    struct Request: Codable {
        var data: RequestData
    }

    struct Response: Codable {
        var data: AppInfoLocalization
        var links: DocumentLink
        var included: [AppInfo]?
    }

    func execute(request: Request, apiAccess: APIAccess) async throws -> Response {
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = try JSONEncoder().encode(request)
        let response: Response = try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
        return response
    }
}
