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

class WillDelete {





//
//    func execute<T: Response>() async throws -> T {
//        EmptyResponse() as! T
//    }
//
//    /*
//     GET https://api.appstoreconnect.apple.com/v1/appScreenshotSets/{id}
//     */
//
//    struct Request {
//        var schreenshotSetId: String
//    }

//    let method = "GET"
//
//    func execute(request: Request, apiAccess: APIAccess) async throws -> AppScreenshotSetResponse {
//        let urlString = "https://api.appstoreconnect.apple.com/v1/appScreenshotSets/\(request.schreenshotSetId)"
//        let url: URL = URL(string: urlString)!
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = method
//        let response: AppScreenshotSetResponse = try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
//        return response
//    }
}
