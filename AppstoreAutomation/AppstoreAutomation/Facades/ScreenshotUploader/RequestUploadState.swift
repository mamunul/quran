//
//  RequestUploadState.swift
//  AppstoreAutomation
//
//  Created by newone on 4/7/22.
//

import Foundation

class RequestUploadState: UploadCommandState {
    var nextStep: DataUploadState?

    private var appScreenshotSetId: String
    private var fileName: String
    private var fileSize: Int
    private var apiAccess: APIAccess

    init(appScreenshotSetId: String, fileName: String, fileSize: Int, apiAccess: APIAccess) {
        self.appScreenshotSetId = appScreenshotSetId
        self.fileName = fileName
        self.fileSize = fileSize
        self.apiAccess = apiAccess
    }

    private func makeAnUploadRequest() async throws -> AppScreenshot {
        let uploadRequestCommand = RequestUploadCommand(apiAccess: apiAccess)
        let response = try await uploadRequestCommand.execute(
            appScreenshotSetId: appScreenshotSetId,
            fileName: fileName,
            fileSize: fileSize
        )
        return response.data
    }

    func execute(uploader: ScreenshotUploader2) async throws {
        let response = try await makeAnUploadRequest()
        nextStep?.appScreenshot = response
        uploader.setStep(step: nextStep)
    }
}
