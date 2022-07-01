//
//  RequestUploadCommand.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 1/7/22.
//

import Foundation

class RequestUploadCommand: Command {
//    POST https://api.appstoreconnect.apple.com/v1/appScreenshots
    struct AppScreenshotSetData {
        var id: String
        var type: String = "appScreenshots"
    }

    struct AppScreenshotSet {
        var data: AppScreenshotSetData
    }

    struct Relationships {
        var appScreenshotSet: AppScreenshotSet
    }

    struct RequestAttributes {
        var fileName: String
        var fileSize: Int
    }

    struct RequestData {
        var attributes: RequestAttributes
        var relationships: Relationships
        var type: String = "appScreenshots"
    }

    struct ScreenshotRequest {
        var data: RequestData
    }

    struct ScreenshotResponse {
        var links: DocumentLink
        var data: ScreenshotGetCommand.AppScreenshot
    }

    func execute<T>() async throws -> T where T: Response {
        T.empty as! T
    }
}
