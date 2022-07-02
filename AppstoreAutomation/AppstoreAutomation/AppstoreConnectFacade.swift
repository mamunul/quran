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

    func createScreenshotSet(appStoreVersionLocalizaitonId: String, screenshotDisplayType: ScreenshotDisplayType) async throws -> String {
        let apiAccess = try verifyAPIAcess()
        let attributes = CreateScreenshotSetCommand.Attributes(screenshotDisplayType: screenshotDisplayType)
        let data = CreateScreenshotSetCommand.AppStoreVersionLocalizationData(id: appStoreVersionLocalizaitonId)
        let appStoreVersionLocalization = CreateScreenshotSetCommand.AppStoreVersionLocalization(data: data)
        let relationship = CreateScreenshotSetCommand.Relationships(appStoreVersionLocalization: appStoreVersionLocalization)
        let data2 = CreateScreenshotSetCommand.RequestData(attributes: attributes, relationships: relationship)
        let request = CreateScreenshotSetCommand.AppScreenshotSetRequest(data: data2)
        let response = try await CreateScreenshotSetCommand().execute(request: request, apiAccess: apiAccess)

        return response.data.id
    }

    func modifyAppInfoLocalization(appInfoLocalizationId: String, attributes: ModifyAppInfoLocalizationCommand.Attributes) async throws {
        let apiAccess = try verifyAPIAcess()
        let requestData = ModifyAppInfoLocalizationCommand.RequestData(attributes: attributes, id: appInfoLocalizationId)
        let request1 = ModifyAppInfoLocalizationCommand.Request(data: requestData)
        let response1 = try await ModifyAppInfoLocalizationCommand().execute(request: request1, apiAccess: apiAccess)
        print(response1)
    }

    func modifyAppStoreVersionLocalization(appStoreVersionLocalizaitonId: String, attributes: ModifyAppStoreVersionLocalizationCommand.Attributes) async throws {
        let apiAccess = try verifyAPIAcess()
        let data = ModifyAppStoreVersionLocalizationCommand.RequestData(attributes: attributes, id: appStoreVersionLocalizaitonId)

        let request2 = ModifyAppStoreVersionLocalizationCommand.LocalizationRequest(data: data)
        let response2 = try await ModifyAppStoreVersionLocalizationCommand().execute(request: request2, apiAccess: apiAccess)
        print(response2)
    }

    func createAppStoreVersionLocalizaiton(appStoreVersionId: String, attributes: CreateAppStoreVersionLocalizationCommand.Attributes) async throws {
        let apiAccess = try verifyAPIAcess()
        let relationship = CreateAppStoreVersionLocalizationCommand.RelationshipData(id: appStoreVersionId)
        let appstoreVersion = CreateAppStoreVersionLocalizationCommand.AppStoreVersion(data: relationship)
        let relationships2 = CreateAppStoreVersionLocalizationCommand.Relationships(appStoreVersion: appstoreVersion)

        let data = CreateAppStoreVersionLocalizationCommand.RequestData(attributes: attributes, relationships: relationships2)

        let request2 = CreateAppStoreVersionLocalizationCommand.LocalizationRequest(data: data)
        let response2 = try await CreateAppStoreVersionLocalizationCommand().execute(request: request2, apiAccess: apiAccess)
        print(response2)
    }

    func createAppInfoLocalization(appInfoId: String, attributes: CreateAppInfoLocalizationCommand.Attributes) async throws {
        let apiAccess = try verifyAPIAcess()
        let appInfoData = CreateAppInfoLocalizationCommand.AppInfoData(id: appInfoId)
        let appInfo = CreateAppInfoLocalizationCommand.AppInfo(data: appInfoData)
        let relationships = CreateAppInfoLocalizationCommand.Relationships(appInfo: appInfo)
        let requestData = CreateAppInfoLocalizationCommand.RequestData(attributes: attributes, relationships: relationships)
        let request1 = CreateAppInfoLocalizationCommand.Request(data: requestData)
        let response1 = try await CreateAppInfoLocalizationCommand().execute(request: request1, apiAccess: apiAccess)
        print(response1)
    }

    func getAppInfoLocalizations(appInfoId: String) async throws -> [CreateAppInfoLocalizationCommand.AppInfoLocalization] {
        let apiAccess = try verifyAPIAcess()
        let request = GetAppInfoLocalizationsCommand.Request(appInfoId: appInfoId)
        let response4 = try await GetAppInfoLocalizationsCommand().execute(request: request, apiAccess: apiAccess)

        return response4.data
    }

    func getScreenshots(screenshotSetId: String) async throws {
        let apiAccess = try verifyAPIAcess()
        let request4 = GetScreenshotCommand.Request(appscreenshotSetId: screenshotSetId)
        let response4 = try await GetScreenshotCommand().execute(request: request4, apiAccess: apiAccess)

        print(response4)
    }

    func getScreenshotSetId(displayType: ScreenshotDisplayType, appStoreLocalizedVersionId: String) async throws -> String? {
        let apiAccess = try verifyAPIAcess()
        let request3 = GetScreenshotSetsCommand.Request(localizationId: appStoreLocalizedVersionId)
        let response3 = try await GetScreenshotSetsCommand().execute(request: request3, apiAccess: apiAccess)
        let screenshotSetId = response3.data.first(where: { $0.attributes.screenshotDisplayType == displayType })?.id

        return screenshotSetId
    }

    func getAppStoreVesionId(platform: GetAppStoreVersionsCommand.Platform, appId: String) async throws -> String? {
        let apiAccess = try verifyAPIAcess()
        let request = GetAppStoreVersionsCommand.Request(appId: appId)
        let response = try await GetAppStoreVersionsCommand().execute(request: request, apiAccess: apiAccess)
        let appPlatformId = response.data.first(where: { $0.attributes.platform == platform })?.id
        return appPlatformId
    }

    func getAppStoreLocalizedVersionId(appStoreVersionId: String, localization: Localization) async throws -> String? {
        let apiAccess = try verifyAPIAcess()
        let request2 = GetAppStoreVersionLocalizationsCommand.Request(appStoreVersionId: appStoreVersionId)
        let response2 = try await GetAppStoreVersionLocalizationsCommand().execute(request: request2, apiAccess: apiAccess)
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
