//
//  GetScreenshotSetsCommand.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 1/7/22.
//

import Foundation

enum ScreenshotDisplayType: String, Codable {
    case APP_IPHONE_65, APP_IPHONE_58, APP_IPHONE_55, APP_IPHONE_47, APP_IPHONE_40, APP_IPHONE_35
    case APP_IPAD_PRO_3GEN_129, APP_IPAD_PRO_3GEN_11, APP_IPAD_PRO_129, APP_IPAD_105, APP_IPAD_97
    case APP_DESKTOP
}

class GetScreenshotSetsCommand {

    struct Attributes: Codable {
        var screenshotDisplayType: ScreenshotDisplayType
    }

    struct AppScreenshotSet: Codable {
        var attributes: Attributes
        var id: String

        var links: DocumentLink

        var type: String
    }

    struct AppScreenshotSetsResponse: Codable {
        var data: [AppScreenshotSet]
        var links: PagedDocumentLinks
    }

    func execute<T: Response>() async throws -> T {
        EmptyResponse() as! T
    }

    /*
     GET \(baseUrl)appScreenshotSets/{id}
     */

    struct Request {
        var localizationId: String
    }

    private let method = Method.get

    func execute(request: Request, apiAccess: APIAccess) async throws -> AppScreenshotSetsResponse {
        let urlString = "\(baseUrl)appStoreVersionLocalizations/\(request.localizationId)/appScreenshotSets"
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        let response: AppScreenshotSetsResponse = try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
        return response
    }
}
