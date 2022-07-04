//
//  Screenshots.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 30/6/22.
//

import Foundation

class CreateScreenshotSetCommand {
    struct Attributes: Codable {
        var screenshotDisplayType: DisplayType
    }

    struct AppStoreVersionLocalizationData: Codable {
        var id: String
        var type = "appStoreVersionLocalizations"
    }

    struct AppStoreVersionLocalization: Codable {
        var data: AppStoreVersionLocalizationData
    }

    struct Relationships: Codable {
        var appStoreVersionLocalization: AppStoreVersionLocalization
    }

    struct RequestData: Codable {
        var attributes: Attributes
        var type: String = "appScreenshotSets"
        var relationships: Relationships
    }

    struct AppScreenshotSetRequest: Codable {
        var data: RequestData
    }

    struct AppScreenshotSet: Codable {
        var attributes: Attributes
        var id: String

        var links: DocumentLink

        var type: String
    }

    struct AppScreenshotSetResponse: Codable {
        var data: AppScreenshotSet
        var links: DocumentLink
    }

    private let method = Method.post
    func execute(appStoreVersionLocalizaitonId: String, displayType: DisplayType, apiAccess: APIAccess) async throws ->
        AppScreenshotSetResponse {
        let attributes = Attributes(screenshotDisplayType: displayType)
        let data = AppStoreVersionLocalizationData(id: appStoreVersionLocalizaitonId)
        let appStoreVersionLocalization = AppStoreVersionLocalization(data: data)
        let relationship = Relationships(appStoreVersionLocalization: appStoreVersionLocalization)
        let data2 = RequestData(attributes: attributes, relationships: relationship)
        let request = AppScreenshotSetRequest(data: data2)

        let urlString = "\(baseUrl)/appScreenshotSets"
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = try JSONEncoder().encode(request)
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let response: AppScreenshotSetResponse = try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
        return response
    }
}

struct PagedDocumentLinks: Codable {
    var first: String?
    var next: String?
    var `self`: String
}
