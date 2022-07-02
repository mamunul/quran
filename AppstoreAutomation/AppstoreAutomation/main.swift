//
//  main.swift
//  AppstoreAutomation
//
//  Created by newone on 30/6/22.
//

enum Localization: String, Codable {
    case en = "en-US"
    case it, ja, ko, fr = "fr-FR", de = "de-DE", ru, es = "es-ES", sv, nb = "no"
    case hongkong = "zh-HK"
    case chineseSimplified = "zh-Hans"
    case chineseTraditional = "zh-Hant"
}

import Foundation

struct APIAccess {
    var secret: String
    var issuerID: String
    var apiKey: String
    var bundleId: String
}

let api = APIAccess(secret: secret, issuerID: issuerID, apiKey: apiKey, bundleId: bundleId)
let facade = AppstoreConnectFacade()
facade.configure(apiAccess: api)

func testModifyAppInfoVersionAPI() {
    Task {
        do {
            let appId = GetAppStoreVersionsCommand.Request.quranApp.appId
            let appInfoId = try await facade.getAppInfoId(appId: appId)
            let localizations = try await facade.getAppInfoLocalizations(appInfoId: appInfoId)

            guard let first = localizations.first(where: { $0.attributes.locale == .es }) else { return }

            let attributes = ModifyAppInfoLocalizationCommand.Attributes(
                name: "skhdfjksh",
                privacyPolicyText: "sdfsdfs",
                privacyPolicyUrl: "http://www.jsfhl.com",
                subtitle: "safdsdfsdf",
                privacyChoicesUrl: "https://www.sjhfsl.org"
            )
            try await facade.modifyAppInfoLocalization(appInfoLocalizationId: first.id, attributes: attributes)
        } catch {
            print(error)
        }
    }
}

func testModifyAppStoreVersionLocalizedAPI() {
    Task {
        do {
            let appId = GetAppStoreVersionsCommand.Request.quranApp.appId
            let appStoreVersionId = try await facade.getAppStoreVesionId(platform: .IOS, appId: appId)
            let appStoreVersionLocalizaitonId = try await facade.getAppStoreLocalizedVersionId(appStoreVersionId: appStoreVersionId, localization: .fr)

            let attributes = try ModifyAppStoreVersionLocalizationCommand.Attributes(
                keywords: "key, word",
                description: "sdfsdfsdfsdfsdfsdfsdf sfsdf sfsdf sfdsdf",
                marketingUrl: "http://www.marketing.com",
                promotionalText: "sdfsdfsdfsdf",
                supportUrl: "http://support.com"
            )
            try await facade.modifyAppStoreVersionLocalization(appStoreVersionLocalizaitonId: appStoreVersionLocalizaitonId, attributes: attributes)
        } catch {
            print(error)
        }
    }
}

func testGetApi() {
    Task {
        do {
            let appId = GetAppStoreVersionsCommand.Request.quranApp.appId
            let appInfoId = try await facade.getAppInfoId(appId: appId)
            try await facade.getAppInfoLocalizations(appInfoId: appInfoId)
            let appPlatformId = try await facade.getAppStoreVesionId(platform: .IOS, appId: appId)
            let localizedVersionId = try await facade.getAppStoreLocalizedVersionId(appStoreVersionId: appPlatformId, localization: .en)
            let screenshotSetId = try await facade.getScreenshotSetId(displayType: .APP_IPHONE_55, appStoreLocalizedVersionId: localizedVersionId)
            try await facade.getScreenshots(screenshotSetId: screenshotSetId)

        } catch {
            print(error)
        }
    }
}

func testCreateALocalizationAPI(facade: AppstoreConnectFacade) {
    Task {
        do {
            let appId = GetAppStoreVersionsCommand.Request.quranApp.appId
            let appInfoId = try await facade.getAppInfoId(appId: appId)
            let attributes =
                CreateAppInfoLocalizationCommand.Attributes(
                    locale: Localization.de,
                    name: "Quran in de-DE"
                )

            try await facade.createAppInfoLocalization(appInfoId: appInfoId, attributes: attributes)

        } catch {
            print(error)
        }
    }
}

testModifyAppStoreVersionLocalizedAPI()
//testModifyAppInfoVersionAPI()
// testGetApi()
// testCreateALocalizationAPI(facade: facade)
RunLoop.main.run()
