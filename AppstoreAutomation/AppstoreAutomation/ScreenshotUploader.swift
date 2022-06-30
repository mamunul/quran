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

    func createScreenshotSet() {
        /*
         POST https://api.appstoreconnect.apple.com/v1/appScreenshotSets
         */
    }

    func delete() {
        /*
         DELETE https://api.appstoreconnect.apple.com/v1/appScreenshotSets/{id}
         */
    }

    func getAppInfo() {
        /*
         GET https://api.appstoreconnect.apple.com/v1/apps/{id}/appInfos
          */

        /*
         {
           "data": [
             {
               "type": "appInfos",
               "id": "726ad1bb-3e1e-40eb-a986-d8a9897e4f1d",
               "attributes": {
                 "appStoreState": "PREPARE_FOR_SUBMISSION",
                 "appStoreAgeRating": "NINE_PLUS",
                 "brazilAgeRating": "TEN",
                 "kidsAgeBand": null
               },
               "relationships": {
                 "app": {
                   "links": {
                     "self": "https://api.appstoreconnect.apple.com/v1/appInfos/726ad1bb-3e1e-40eb-a986-d8a9897e4f1d/relationships/app",
                     "related": "https://api.appstoreconnect.apple.com/v1/appInfos/726ad1bb-3e1e-40eb-a986-d8a9897e4f1d/app"
                   }
                 },
                 "appInfoLocalizations": {
                   "links": {
                     "self": "https://api.appstoreconnect.apple.com/v1/appInfos/726ad1bb-3e1e-40eb-a986-d8a9897e4f1d/relationships/appInfoLocalizations",
                     "related": "https://api.appstoreconnect.apple.com/v1/appInfos/726ad1bb-3e1e-40eb-a986-d8a9897e4f1d/appInfoLocalizations"
                   }
                 },
                 "primaryCategory": {
                   "links": {
                     "self": "https://api.appstoreconnect.apple.com/v1/appInfos/726ad1bb-3e1e-40eb-a986-d8a9897e4f1d/relationships/primaryCategory",
                     "related": "https://api.appstoreconnect.apple.com/v1/appInfos/726ad1bb-3e1e-40eb-a986-d8a9897e4f1d/primaryCategory"
                   }
                 },
                 "primarySubcategoryOne": {
                   "links": {
                     "self": "https://api.appstoreconnect.apple.com/v1/appInfos/726ad1bb-3e1e-40eb-a986-d8a9897e4f1d/relationships/primarySubcategoryOne",
                     "related": "https://api.appstoreconnect.apple.com/v1/appInfos/726ad1bb-3e1e-40eb-a986-d8a9897e4f1d/primarySubcategoryOne"
                   }
                 },
                 "primarySubcategoryTwo": {
                   "links": {
                     "self": "https://api.appstoreconnect.apple.com/v1/appInfos/726ad1bb-3e1e-40eb-a986-d8a9897e4f1d/relationships/primarySubcategoryTwo",
                     "related": "https://api.appstoreconnect.apple.com/v1/appInfos/726ad1bb-3e1e-40eb-a986-d8a9897e4f1d/primarySubcategoryTwo"
                   }
                 },
                 "secondaryCategory": {
                   "links": {
                     "self": "https://api.appstoreconnect.apple.com/v1/appInfos/726ad1bb-3e1e-40eb-a986-d8a9897e4f1d/relationships/secondaryCategory",
                     "related": "https://api.appstoreconnect.apple.com/v1/appInfos/726ad1bb-3e1e-40eb-a986-d8a9897e4f1d/secondaryCategory"
                   }
                 },
                 "secondarySubcategoryOne": {
                   "links": {
                     "self": "https://api.appstoreconnect.apple.com/v1/appInfos/726ad1bb-3e1e-40eb-a986-d8a9897e4f1d/relationships/secondarySubcategoryOne",
                     "related": "https://api.appstoreconnect.apple.com/v1/appInfos/726ad1bb-3e1e-40eb-a986-d8a9897e4f1d/secondarySubcategoryOne"
                   }
                 },
                 "secondarySubcategoryTwo": {
                   "links": {
                     "self": "https://api.appstoreconnect.apple.com/v1/appInfos/726ad1bb-3e1e-40eb-a986-d8a9897e4f1d/relationships/secondarySubcategoryTwo",
                     "related": "https://api.appstoreconnect.apple.com/v1/appInfos/726ad1bb-3e1e-40eb-a986-d8a9897e4f1d/secondarySubcategoryTwo"
                   }
                 }
               },
               "links": {
                 "self": "https://api.appstoreconnect.apple.com/v1/appInfos/726ad1bb-3e1e-40eb-a986-d8a9897e4f1d"
               }
             }
           ],
           "links": {
             "self": "https://api.appstoreconnect.apple.com/v1/apps/1462965264/appInfos"
           },
           "meta": {
             "paging": {
               "total": 1,
               "limit": 50
             }
           }
         }

         */
    }

    func getAppLocaziedInfo() {
        /*
         GET https://api.appstoreconnect.apple.com/v1/appInfos/{id}/appInfoLocalizations
         */
    }

    func getScreenshots() {
        /*
         GET https://api.appstoreconnect.apple.com/v1/appScreenshotSets/{id}
         */
    }

    func getAppStoreVersions() {
        /*
         GET https://api.appstoreconnect.apple.com/v1/apps/{id}/appStoreVersions

         GET https://api.appstoreconnect.apple.com/v1/appStoreVersions/{id}

         GET https://api.appstoreconnect.apple.com/v1/appStoreVersions/{id}/appStoreVersionLocalizations
         */
    }

    func getViersionLocalization() {
        /*
         GET https://api.appstoreconnect.apple.com/v1/appStoreVersionLocalizations/{id}
         */
    }

    func createVersionLocalization() {
        /*
         POST https://api.appstoreconnect.apple.com/v1/appStoreVersionLocalizations
         */

        /*

         POST https://api.appstoreconnect.apple.com/v1/appStoreVersionLocalizations
         {
           "data": {
             "type": "appStoreVersionLocalizations",
             "attributes": {
               "locale": "en-US",
               "description": "Go wild and discover trails, parks and off-the-beaten-track terrain with Forest Explorer. Whether you’re bushwalking in the outback or looking for a quick local hike, Forest Explorer has thousands of trails and destinations from around the globe to explore.",
               "keywords": "hiking, trails, backcountry, parks, path, terrain, forest",
               "marketingUrl": "http://www.apple.com/forestexplorer",
               "promotionalText": "Get Forest Explorer free for a limited time.",
               "supportUrl": "https://support.apple.com",
               "whatsNew": "Now includes trails in Europe and South America"
             },
             "relationships": {
               "appStoreVersion": {
                 "data": {
                   "type": "appStoreVersions",
                   "id": "54457681-4b65-4071-a636-ea66cb98c8e9"
                 }
               }
             }
           }
         }
         */

        /*
         {
           "data": {
             "type": "appStoreVersionLocalizations",
             "id": "af806ced-8826-4a9d-8a0f-9f3402ce3629",
             "attributes": {
               "locale": "en-US",
               "description": "Go wild and discover trails, parks and off-the-beaten-track terrain with Forest Explorer. Whether you’re bushwalking in the outback or looking for a quick local hike, Forest Explorer has thousands of trails and destinations from around the globe to explore.",
               "keywords": "hiking, trails, backcountry, parks, path, terrain, forest",
               "marketingUrl": "http://www.apple.com/forestexplorer",
               "promotionalText": "Get Forest Explorer free for a limited time.",
               "supportUrl": "https://support.apple.com",
               "whatsNew": "Now includes trails in Europe and South America"
             },
             "relationships": {
               "appStoreVersion": {
                 "links": {
                   "self": "https://api.appstoreconnect.apple.com/v1/appStoreVersionLocalizations/af806ced-8826-4a9d-8a0f-9f3402ce3629/relationships/appStoreVersion",
                   "related": "https://api.appstoreconnect.apple.com/v1/appStoreVersionLocalizations/af806ced-8826-4a9d-8a0f-9f3402ce3629/appStoreVersion"
                 }
               },
               "appScreenshotSets": {
                 "links": {
                   "self": "https://api.appstoreconnect.apple.com/v1/appStoreVersionLocalizations/af806ced-8826-4a9d-8a0f-9f3402ce3629/relationships/appScreenshotSets",
                   "related": "https://api.appstoreconnect.apple.com/v1/appStoreVersionLocalizations/af806ced-8826-4a9d-8a0f-9f3402ce3629/appScreenshotSets"
                 }
               },
               "appPreviewSets": {
                 "links": {
                   "self": "https://api.appstoreconnect.apple.com/v1/appStoreVersionLocalizations/af806ced-8826-4a9d-8a0f-9f3402ce3629/relationships/appPreviewSets",
                   "related": "https://api.appstoreconnect.apple.com/v1/appStoreVersionLocalizations/af806ced-8826-4a9d-8a0f-9f3402ce3629/appPreviewSets"
                 }
               }
             },
             "links": {
               "self": "https://api.appstoreconnect.apple.com/v1/appStoreVersionLocalizations/af806ced-8826-4a9d-8a0f-9f3402ce3629"
             }
           },
           "links": {
             "self": "https://api.appstoreconnect.apple.com/v1/appStoreVersionLocalizations/af806ced-8826-4a9d-8a0f-9f3402ce3629"
           }
         }
         */
    }

    func deleteVersionLocalization() {
        /*
         DELETE https://api.appstoreconnect.apple.com/v1/appStoreVersionLocalizations/{id}
         */
    }
}
