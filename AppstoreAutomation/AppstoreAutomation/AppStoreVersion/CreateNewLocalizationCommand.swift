//
//  CreateNewLocalizationCommand.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 1/7/22.
//

import Foundation

class CreateNewLocalizationCommand {
    let method = "POST"
    let url = "https://api.appstoreconnect.apple.com/v1/appStoreVersionLocalizations"

    struct RelationshipData {
        var type: String
        var id: String
    }

    struct Attributes {
        var locale: String
        var description: String
        var keywords: String
        var marketingUrl: String
        var promotionalText: String
        var supportUrl: String
        var whatsNew: String
    }

    struct Relationships {
        var appStoreVersion: RelationshipData
    }

    struct RequestData {
        var type: String
        var attributes: Attributes
        var relationships: Relationships
    }

    struct LocalizationRequest {
        var data: RequestData
    }

    struct ResponseData {
        var type: String
        var attributes: Attributes
        var id: String
    }

    struct LocalizationResponse {
        var data: ResponseData
    }

    func execute() {
//        VersionLocalizationResponse

//        VersionLocalizationRequest
    }
}
