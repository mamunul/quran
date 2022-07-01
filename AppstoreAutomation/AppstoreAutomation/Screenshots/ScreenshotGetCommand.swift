//
//  ScreenshotGetCommand.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 1/7/22.
//

import Foundation

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
