//
//  ScreenshotUploader2.swift
//  AppstoreAutomation
//
//  Created by newone on 4/7/22.
//

import Foundation
import CryptoKit

protocol UploadCommandState {
    func execute(uploader: ScreenshotUploader2) async throws
}

class ScreenshotUploader2 {
    private var currentStep: UploadCommandState?
    func upload(appScreenshotSetId: String, apiAccess: APIAccess, screenshot: Screenshot) async throws {
        let data = try Data(contentsOf: screenshot.url)
        let fileName = screenshot.url.lastPathComponent
        let md5Checksum = Insecure.MD5.hash(data: data).map { String(format: "%02hhx", $0) }.joined()

        let commitStep = CommitUploadState(checksum: md5Checksum, apiAccess: apiAccess)
        let requestUploadStep = RequestUploadState(
            appScreenshotSetId: appScreenshotSetId,
            fileName: fileName,
            fileSize: data.count,
            apiAccess: apiAccess
        )

        let dataUploadStep = DataUploadState(assetData: data, apiAccess: apiAccess)
        dataUploadStep.nextStep = commitStep
        requestUploadStep.nextStep = dataUploadStep
        currentStep = requestUploadStep

        while currentStep != nil {
            try await currentStep?.execute(uploader: self)
        }
    }

    func setStep(step: UploadCommandState?) {
        currentStep = step
    }
}
