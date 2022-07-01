//
//  GetALocalizationCommand.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 1/7/22.
//

import Foundation

class GetALocalizationCommand {
    struct AppStoreVersionLocalizationResponse {
        var data: GetAllLocalizationsCommand.AppStoreVersionLocalization
        var included: [Any] // AppStoreVersion, AppScreenshotSet, AppPreviewSet
        var links: DocumentLink
    }

    func getViersionLocalization() {
        /*
         GET https://api.appstoreconnect.apple.com/v1/appStoreVersionLocalizations/{id}
         */

        /*

         Query :
         include
         [string]
         Possible values: appPreviewSets, appScreenshotSets, appStoreVersion
         */
    }
}
