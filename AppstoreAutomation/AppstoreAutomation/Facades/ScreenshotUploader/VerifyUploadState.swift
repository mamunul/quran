//
//  VerifyUploadState.swift
//  AppstoreAutomation
//
//  Created by newone on 4/7/22.
//

import Foundation

class VerifyUploadState: UploadCommandState {
    var failedStep: CancelUploadState?
    func execute(uploader: ScreenshotUploader2) async throws {
        uploader.setStep(step: nil)
    }
}
