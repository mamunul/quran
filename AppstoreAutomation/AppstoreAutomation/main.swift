//
//  main.swift
//  AppstoreAutomation
//
//  Created by newone on 30/6/22.
//

enum Localization: String {
    case us = "en-US"
    case it, ja, ko, fr, de, ru, es, sv, nb
    case hongkong = "zh-HK"
    case chineseSimplified = "zh-Hans"
    case chineseTraditional = "zh-Hant"
}

import Foundation

struct APIAccess {
    var secret: String
    var issuerID: String
    var apiKey: String
}

func testApi() {
    let api = APIAccess(secret: secret, issuerID: issuerID, apiKey: apiKey)
    let request = GetAllPlatformVersionCommand.Request.quranApp
    Task {
        do {
            let response = try await GetAllPlatformVersionCommand().execute(request: request, apiAccess: api)
            guard let appPlatformId = response.data.first(where: { $0.attributes.platform == .IOS })?.id else { return }
            let request2 = GetAllLocalizationsCommand.Request(appStoreVersionId: appPlatformId)

            let response2 = try await GetAllLocalizationsCommand().execute(request: request2, apiAccess: api)

            guard let localizedVersionId = response2.data.first(where: { $0.attributes.locale == Localization.us.rawValue })?.id else { return }
            let request = GetScreenshotSetsCommand.Request(localizationId: localizedVersionId)
            let response3 = try await GetScreenshotSetsCommand().execute(request: request, apiAccess: api)

            guard let screenshotSetId = response3.data.first(where: { $0.attributes.screenshotDisplayType == .APP_IPHONE_55 })?.id else { return }
            let request = GetScreenshotCommand.Request(appscreenshotSetId: screenshotSetId)
            let response4 = try await GetScreenshotCommand().execute(request: request, apiAccess: api)

            print(response4)
        } catch {
            print(error)
        }
    }

//    GetAllPlatformVersionCommand().execute(request: <#T##Request#>, apiAccess: api)
}

testApi()
RunLoop.main.run()
