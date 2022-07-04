//
//  DataUploadState.swift
//  AppstoreAutomation
//
//  Created by newone on 4/7/22.
//

import Foundation

class DataUploadState: UploadCommandState {
    var nextStep: CommitUploadState?
    var failedState: CancelUploadState?
    var appScreenshot: AppScreenshot?
    private var assetData: Data
    private var apiAccess: APIAccess

    init(assetData: Data, apiAccess: APIAccess) {
        self.assetData = assetData
        self.apiAccess = apiAccess
    }

    private func uploadTheAsset() async throws {
        let uploads = appScreenshot?.attributes.uploadOperations ?? []
        let uploadCommand = DataUploadCommand(apiAccess: apiAccess)
        for upload in uploads {
            let subData = assetData.subdata(in: upload.offset ..< upload.length + upload.offset)
            try await uploadCommand.execute(upload: upload, data: subData)
        }
    }

    func execute(uploader: ScreenshotUploader2) async throws {
        failedState = CancelUploadState(apiAccess: apiAccess)
        failedState?.reservationId = appScreenshot?.id
        do {
            try await uploadTheAsset()
            nextStep?.reservationId = appScreenshot?.id
            uploader.setStep(step: nextStep)
        } catch {
            uploader.setStep(step: failedState)
        }
    }
}
