//
//  main.swift
//  AppstoreAutomation
//
//  Created by newone on 30/6/22.
//

import Foundation

let api = APIAccess(secret: secret, issuerID: issuerID, apiKey: apiKey, bundleId: bundleId)
let facade = AppstoreConnectFacade()
facade.configure(apiAccess: api)

func testUploadScreenshot() {
    Task {
        do {
            let basePath = "Documents/Anonymous Appstore/ScreenshotsGeneration/NewScreenshots/iPhoneSEPlus/de/TitleEditorView.png"
            let homeDirectory = FileManager.default.homeDirectoryForCurrentUser

            let folderUrl = homeDirectory.appendingPathComponent(basePath, isDirectory: false)
            let screenshot = ScreenshotUploader.Screenshot(url: folderUrl, displayType: .APP_IPHONE_55, locale: .fr)

            let appId = GetAppStoreVersionsCommand.Request.quranApp.appId
            guard let appPlatformId = try await facade.getAppStoreVesionId(platform: .IOS, appId: appId) else { return }
            guard let localizedVersionId = try await facade.getAppStoreLocalizedVersionId(appStoreVersionId: appPlatformId, localization: .fr) else { return }
            var appScreenshotSetId = try await facade.getScreenshotSetId(displayType: .APP_IPHONE_55, appStoreLocalizedVersionId: localizedVersionId)

            if appScreenshotSetId == nil {
                appScreenshotSetId = try await facade.createScreenshotSet(appStoreVersionLocalizaitonId: localizedVersionId, screenshotDisplayType: .APP_IPHONE_55)
            }

            try await ScreenshotUploader().upload(appScreenshotSetId: appScreenshotSetId!, apiAccess: api, screenshot: screenshot)

        } catch {
            print(error)
        }
    }
}

testUploadScreenshot()
// testModifyAppStoreVersionLocalizedAPI()
// testModifyAppInfoVersionAPI()
// testGetApi(facade: facade)
// testCreateALocalizationAPI(facade: facade)
RunLoop.main.run()
