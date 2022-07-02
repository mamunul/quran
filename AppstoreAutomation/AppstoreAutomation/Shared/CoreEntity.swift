//
//  CoreEntity.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 2/7/22.
//

import Foundation

enum Localization: String, Codable {
    case en = "en-US"
    case it, ja, ko, fr = "fr-FR", de = "de-DE", ru, es = "es-ES", sv, nb = "no"
    case hongkong = "zh-HK"
    case chineseSimplified = "zh-Hans"
    case chineseTraditional = "zh-Hant"
}

struct APIAccess {
    var secret: String
    var issuerID: String
    var apiKey: String
    var bundleId: String
}
