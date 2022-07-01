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
    enum UploadState: String {
        case AWAITING_UPLOAD, UPLOAD_COMPLETE, COMPLETE, FAILED
    }

    struct AppMediaStateError {
        var code: String
        var description: String
    }

    struct AppMediaAssetState {
        var errors: [AppMediaStateError]
        var state: UploadState
        var warnings: [AppMediaStateError]
    }

    struct HttpHeader {
        var name: String
        var value: String
    }

    struct UploadOperation {
        var length: Int
        var method: String
        var offset: Int
        var requestHeaders: [HttpHeader]
        var url: String
    }

    struct ImageAsset {
        var templateUrl: String
        var height: Int
        var width: Int
    }

    struct Attributes {
        var assetDeliveryState: AppMediaAssetState
        var assetToken: String
        var assetType: String
        var fileName: String
        var fileSize: Int
        var imageAsset: ImageAsset
        var sourceFileChecksum: String
        var uploadOperations: [UploadOperation]
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

class ScreenshotSetDeleteCommand {
    /*
     DELETE https://api.appstoreconnect.apple.com/v1/appScreenshotSets/{id}
     */
}
