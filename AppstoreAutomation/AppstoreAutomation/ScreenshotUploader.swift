//
//  ScreenshotUploader.swift
//  AppstoreAutomation
//
//  Created by newone on 30/6/22.
//

import Foundation

protocol IUploadable {
    func makeAnUploadRequest()
    func uploadTheAsset()
    func commitTheUpload()
    func verifyUpload()
}

extension IUploadable { // Template Method
    func upload() {
        makeAnUploadRequest()
        uploadTheAsset()
        commitTheUpload()
        verifyUpload()
    }
}

class ScreenshotUploader: IUploadable {
    func makeAnUploadRequest() {
        /*
         POST /v1/appScreenshots
         {
             "data": {
                 "type": "appScreenshots",
                 "attributes": {
                     "fileSize": 11097,
                     "fileName": "my_screenshot.png"
                 },
                 "relationships": {
                     "appScreenshotSet": {
                         "data": {
                             "type": "appScreenshotSets",
                             "id": "54594240-5c4c-4a0f-add1-b4cb7e52d166"
                         }
                     }
                 }
             }
         }
          */

        /* Response
         {
             "data" : {
                 "type" : "appScreenshots",
                 "id" : "4d62262c-4ec1-4d89-b82c-c7b7a402e866",
                 "attributes" : {
                     "fileSize" : 11097,
                     "fileName" : "my_screenshot.png",
                     "sourceFileChecksum" : null,
                     "imageAsset" : null,
                     "assetToken" : "PurpleSource62/v4/c4/c6/5f/c4c65fe0-b616-0454-d71b-7771b95f74f1/4d62262c-4ec1-4d89-b82c-c7b7a402e866_null_54594240-5c4c-4a0f-add1-b4cb7e52d166_my_screenshot.png",
                     "assetType" : "SCREENSHOT",
                     "uploadOperations" : [ {
                         "method" : "PUT",
                         "url" : "https://store-030.blobstore.apple.com/itms6-assets-massilia-030001/PurpleSource62%2Fv4%2Fc4%2Fc6%2F5f%2Fc4c65fe0-b616-0454-d71b-7771b95f74f1%2FgzsRhfc7iZIvrJoG3mdTlRGfH-Hu1JJBY_Y82m_QlKU_U003d-1587670858469?uploadId=5ae7a610-859a-11ea-adb0-d8c497b45469&Signature=nL9SQyAh4l1tEwoWQhiflX270Zs%3D&AWSAccessKeyId=MKIA4IEXBU1OGIOUHE96&partNumber=1&Expires=1588275658",
                         "length" : 11097,
                         "offset" : 0,
                         "requestHeaders" : [ {
                             "name" : "Content-Type",
                             "value" : "image/png"
                         } ]
                    } ],
                    "assetDeliveryState" : {
                        "errors" : [ ],
                        "state" : "AWAITING_UPLOAD"
                    }
                },
                "relationships" : {
                    "appScreenshotSet" : {
                        "links" : {
                            "self" : "https://api.appstoreconnect.apple.com/v1/appScreenshots/4d62262c-4ec1-4d89-b82c-c7b7a402e866/relationships/appScreenshotSet",
                             "related" : "https://api.appstoreconnect.apple.com/v1/appScreenshots/4d62262c-4ec1-4d89-b82c-c7b7a402e866/appScreenshotSet"
                        }
                    }
                },
                "links" : {
                    "self" : "https://api.appstoreconnect.apple.com/v1/appScreenshots/4d62262c-4ec1-4d89-b82c-c7b7a402e866"
                }
            },
            "links" : {
                 "self" : "https://api.appstoreconnect.apple.com/v1/appScreenshots"
             }
         }
         */
    }

    func uploadTheAsset() {
    }

    func commitTheUpload() {
        /*
         PATCH /v1/appScreenshots/4d62262c-4ec1-4d89-b82c-c7b7a402e866
         {
             "data": {
                 "type": "appScreenshots",
                 "id": "4d62262c-4ec1-4d89-b82c-c7b7a402e866",
                 "attributes": {
                     "uploaded": true,
                     "sourceFileChecksum": "1a79a4d60de6718e8e5b326e338ae533"
                 }
             }
         }
          */
    }

    func verifyUpload() {
    }
}
