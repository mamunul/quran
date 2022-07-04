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
        let response =
            try await ModifyAppInfoLocalizationCommand().execute(
                appInfoLocalizationId: appInfoLocalizationId,
                attributes: attributes,
                apiAccess: apiAccess
            )
        print(response)
    }

    func modifyAppStoreVersionLocalization(appStoreVersionLocalizaitonId: String, attributes: AppStoreVersionLocalizationAttributes) async throws {
        let apiAccess = try verifyAPIAcess()
        let response =
            try await ModifyAppStoreVersionLocalizationCommand().execute(
                appStoreVersionLocalizaitonId: appStoreVersionLocalizaitonId,
                attributes: attributes,
                apiAccess: apiAccess
            )
        print(response)
    }

    func createAppStoreVersionLocalizaiton(appStoreVersionId: String, attributes: AppStoreVersionLocalizationAttributes) async throws ->
        String {
        let apiAccess = try verifyAPIAcess()
        let response =
            try await CreateAppStoreVersionLocalizationCommand().execute(
                appStoreVersionId: appStoreVersionId,
                attributes: attributes,
                apiAccess: apiAccess
            )
        print(response)
        return response.data.id
    }

    func createAppInfoLocalization(appInfoId: String, attributes: AppInfoLocalizationAttributes) async throws -> String {
        let apiAccess = try verifyAPIAcess()

        let response =
            try await CreateAppInfoLocalizationCommand().execute(
                appInfoId: appInfoId,
                attributes: attributes,
                apiAccess: apiAccess
            )
        print(response)

        return response.data.id
    }

    func getAppInfoLocalizations(appInfoId: String) async throws -> [AppInfoLocalization] {
        let apiAccess = try verifyAPIAcess()
        let response = try await GetAppInfoLocalizationsCommand().execute(appInfoId: appInfoId, apiAccess: apiAccess)

        return response.data
    }

    func getScreenshots(screenshotSetId: String) async throws -> [AppScreenshot] {
        let apiAccess = try verifyAPIAcess()
        let response = try await GetScreenshotCommand().execute(screenshotSetId: screenshotSetId, apiAccess: apiAccess)
        return response.data
    }

    func getScreenshotSets(appStoreLocalizedVersionId: String) async throws -> [AppScreenshotSet] {
        let apiAccess = try verifyAPIAcess()
        let response =
            try await GetScreenshotSetsCommand().execute(
                appStoreLocalizedVersionId: appStoreLocalizedVersionId,
                apiAccess: apiAccess
            )

        return response.data
    }

    func getScreenshotSetId(displayType: DisplayType, appStoreLocalizedVersionId: String) async throws -> String? {
        let response = try await getScreenshotSets(appStoreLocalizedVersionId: appStoreLocalizedVersionId)
        let screenshotSetId = response.first(where: { $0.attributes.screenshotDisplayType == displayType })?.id

        return screenshotSetId
    }

    func getAppstoreVersions(appId: String) async throws -> [AppStoreVersion] {
        let apiAccess = try verifyAPIAcess()
        let response = try await GetAppStoreVersionsCommand().execute(appId: appId, apiAccess: apiAccess)
        return response.data
    }

    func getAppStoreVesionId(platform: Platform, appId: String) async throws -> String? {
        let response = try await getAppstoreVersions(appId: appId)
        let appPlatformId = response.first(where: { $0.attributes.platform == platform })?.id
        return appPlatformId
    }

    func getAppStoreVersionLocalizations(appStoreVersionId: String) async throws ->
        [AppStoreVersionLocalization] {
        let apiAccess = try verifyAPIAcess()
        let response =
            try await GetAppStoreVersionLocalizationsCommand().execute(
                appStoreVersionId: appStoreVersionId,
                apiAccess: apiAccess
            )

        return response.data
    }

    func getAppStoreLocalizedVersionId(appStoreVersionId: String, localization: Localization) async throws -> String? {
        let localizations = try await getAppStoreVersionLocalizations(appStoreVersionId: appStoreVersionId)
        let localizedVersionId = localizations.first(where: { $0.attributes.locale == localization })?.id
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
        let response = try await GetAppInfoCommand().execute(appId: appId, apiAccess: apiAccess)

        let appInfoId = response.data.first?.id
        return appInfoId
    }

    deinit {
        invalidateAPIAccess()
    }
}
