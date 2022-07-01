//
//  GetAllLocalizationsCommand.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 1/7/22.
//

import Foundation

class GetAllLocalizationsCommand {
    struct AppStoreVersionLocalization {
        var attributes: CreateNewLocalizationCommand.Attributes
        var id: String
        var links: DocumentLink
    }

    struct AppStoreVersionLocalizationsResponse {
        var data: [AppStoreVersionLocalization]

        var links: DocumentLink
    }

    func getAppStoreVersions() {
        /*
         GET https://api.appstoreconnect.apple.com/v1/appStoreVersions/{id}/appStoreVersionLocalizations
         */
    }
}
