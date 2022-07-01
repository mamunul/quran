//
//  CommitAssetUploadCommand.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 1/7/22.
//

import Foundation

class CommitAssetUploadCommand {
    /*
     PATCH /v1/appScreenshots/4d62262c-4ec1-4d89-b82c-c7b7a402e866
     */

    struct RequestDataAttributes {
        var uploaded: Bool
        var sourceFileChecksum: String
    }

    struct RequestData {
        var type = "appScreenshots"
        var id: String
        var attributes: RequestDataAttributes
    }

    struct UploadCommitRequest {
        var data: RequestData
    }
}
