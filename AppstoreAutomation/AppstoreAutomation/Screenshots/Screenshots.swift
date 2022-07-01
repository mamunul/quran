//
//  Screenshots.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 30/6/22.
//

import Foundation

class CreateScreenshotSetCommand: Command {
    /*
     POST https://api.appstoreconnect.apple.com/v1/appScreenshotSets
     */
    struct RequestData {
        var attributes: GetScreenshotSetsCommand.Attributes
        var type: String
    }

    struct AppScreenshotSetRequest {
        var data: RequestData
    }

    func execute<T: Response>() async throws -> T {
        EmptyResponse() as! T
    }
}

class GetScreenshotSetsCommand: Command {
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

struct PagedDocumentLinks {
    var first: String
    var next: String
    var `self`: String
}

class ScreenshotGetCommand {
    struct Attributes {
    }

    struct AppScreenshot {
        var attributes: Attributes
        var id: String

        var links: DocumentLink
        var type: String = "appScreenshots"
    }

    struct AppScreenshotsResponse {
        var data: [AppScreenshot]

        var links: PagedDocumentLinks
    }
}

class ScreennshotSetDeleteCommand {
    /*
     DELETE https://api.appstoreconnect.apple.com/v1/appScreenshotSets/{id}
     */
}
