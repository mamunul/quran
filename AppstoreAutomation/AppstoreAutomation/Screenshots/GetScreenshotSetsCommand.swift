//
//  GetScreenshotSetsCommand.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 1/7/22.
//

import Foundation

class GetScreenshotSetsCommand {
    enum ScreenshotDisplayType: String {
        case APP_IPHONE_65, APP_IPHONE_58, APP_IPHONE_55, APP_IPHONE_47, APP_IPHONE_40, APP_IPHONE_35
        case APP_IPAD_PRO_3GEN_129, APP_IPAD_PRO_3GEN_11, APP_IPAD_PRO_129, APP_IPAD_105, APP_IPAD_97
        case APP_DESKTOP
    }

    struct Attributes {
        var screenshotDisplayType: ScreenshotDisplayType
    }

    struct AppScreenshotSet {
        var attributes: Attributes
        var id: String

        var links: DocumentLink

        var type: String
    }

    struct AppScreenshotSetResponse {
        var data: AppScreenshotSet
        var links: DocumentLink
    }

    func execute<T: Response>() async throws -> T {
        EmptyResponse() as! T
    }

    /*
     GET https://api.appstoreconnect.apple.com/v1/appScreenshotSets/{id}
     */
}
