//
//  AppstoreConnectFacade.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 2/7/22.
//

import Foundation

class AppstoreConnectFacade {
    enum APIError: Error {
        case emptyData, configureAPIACcess
    }

    private var apiAccess: APIAccess?
    func configure(apiAccess: APIAccess) {
        self.apiAccess = apiAccess
    }

    func invalidateAPIAccess() {
    }

    func createScreenshotSet(appStoreVersionLocalizaitonId: String, screenshotDisplayType: DisplayType) async throws -> String {
        let apiAccess = try verifyAPIAcess()
        let response = try await CreateScreenshotSetCommand().execute(
            appStoreVersionLocalizaitonId: appStoreVersionLocalizaitonId,
            displayType: screenshotDisplayType,
            apiAccess: apiAccess
        )

        return response.data.id
    }

    func modifyAppInfoLocalization(appInfoLocalizationId: String, attributes: AppInfoLocalizationAttributes) async throws {
        let apiAccess = try verifyAPIAcess()
        let response1 =
            try await ModifyAppInfoLocalizationCommand().execute(
                appInfoLocalizationId: appInfoLocalizationId,
                attributes: attributes,
                apiAccess: apiAccess
            )
        print(response1)
    }

    func modifyAppStoreVersionLocalization(appStoreVersionLocalizaitonId: String, attributes: AppStoreVersionLocalizationAttributes) async throws {
        let apiAccess = try verifyAPIAcess()
        let response2 =
            try await ModifyAppStoreVersionLocalizationCommand().execute(
                appStoreVersionLocalizaitonId: appStoreVersionLocalizaitonId,
                attributes: attributes,
                apiAccess: apiAccess
            )
        print(response2)
    }

    func createAppStoreVersionLocalizaiton(appStoreVersionId: String, attributes: AppStoreVersionLocalizationAttributes) async throws {
        let apiAccess = try verifyAPIAcess()
        let response2 =
            try await CreateAppStoreVersionLocalizationCommand().execute(
                appStoreVersionId: appStoreVersionId,
                attributes: attributes,
                apiAccess: apiAccess
            )
        print(response2)
    }

    func createAppInfoLocalization(appInfoId: String, attributes: AppInfoLocalizationAttributes) async throws {
        let apiAccess = try verifyAPIAcess()

        let response1 =
            try await CreateAppInfoLocalizationCommand().execute(
                appInfoId: appInfoId,
                attributes: attributes,
                apiAccess: apiAccess
            )
        print(response1)
    }

    func getAppInfoLocalizations(appInfoId: String) async throws -> [AppInfoLocalization] {
        let apiAccess = try verifyAPIAcess()
        let response4 = try await GetAppInfoLocalizationsCommand().execute(appInfoId: appInfoId, apiAccess: apiAccess)

        return response4.data
    }

    func getScreenshots(screenshotSetId: String) async throws {
        let apiAccess = try verifyAPIAcess()
        let response4 = try await GetScreenshotCommand().execute(screenshotSetId: screenshotSetId, apiAccess: apiAccess)

        print(response4)
    }

    func getScreenshotSetId(displayType: DisplayType, appStoreLocalizedVersionId: String) async throws -> String? {
        let apiAccess = try verifyAPIAcess()
        let response3 =
        try await GetScreenshotSetsCommand().execute(
            appStoreLocalizedVersionId: appStoreLocalizedVersionId,
            apiAccess: apiAccess
        )
        let screenshotSetId = response3.data.first(where: { $0.attributes.screenshotDisplayType == displayType })?.id

        return screenshotSetId
    }

    func getAppStoreVesionId(platform: Platform, appId: String) async throws -> String? {
        let apiAccess = try verifyAPIAcess()

        let response = try await GetAppStoreVersionsCommand().execute(appId: appId, apiAccess: apiAccess)
        let appPlatformId = response.data.first(where: { $0.attributes.platform == platform })?.id
        return appPlatformId
    }

    func getAppStoreLocalizedVersionId(appStoreVersionId: String, localization: Localization) async throws -> String? {
        let apiAccess = try verifyAPIAcess()
        let response2 =
            try await GetAppStoreVersionLocalizationsCommand().execute(
                appStoreVersionId: appStoreVersionId,
                localization: localization,
                apiAccess: apiAccess
            )
        let localizedVersionId = response2.data.first(where: { $0.attributes.locale == localization })?.id
        return localizedVersionId
    }

    private func verifyAPIAcess() throws -> APIAccess {
        guard let apiAccess = apiAccess else {
            throw APIError.configureAPIACcess
        }

        return apiAccess
    }

    func getAppInfoId(appId: String) async throws -> String? {
        let apiAccess = try verifyAPIAcess()
        let request4 = GetAppInfoCommand.Request(appId: appId)
        let response4 = try await GetAppInfoCommand().execute(request: request4, apiAccess: apiAccess)

        let appInfoId = response4.data.first?.id
        return appInfoId
    }

    deinit {
        invalidateAPIAccess()
    }
}
