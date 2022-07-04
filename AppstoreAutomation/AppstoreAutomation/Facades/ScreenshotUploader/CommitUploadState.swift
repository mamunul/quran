//
//  CommitUploadState.swift
//  AppstoreAutomation
//
//  Created by newone on 4/7/22.
//

import Foundation

class CommitUploadState: UploadCommandState {
    let nextStep = VerifyUploadState()
    var failedStep: CancelUploadState?
    var reservationId: String?
    private var checksum: String
    private var apiAccess: APIAccess

    init(checksum: String, apiAccess: APIAccess) {
        self.checksum = checksum
        self.apiAccess = apiAccess
    }

    private func commitTheUpload() async throws {
        guard let reservationId = reservationId else {
            return
        }

        let commitUploadCommand = CommitAssetUploadCommand(apiAccess: apiAccess)
        try await commitUploadCommand.execute(
            reservationId: reservationId,
            sourceFileChecksum: checksum,
            access: apiAccess
        )
    }

    func execute(uploader: ScreenshotUploader) async throws {
        failedStep = CancelUploadState(apiAccess: apiAccess)
        failedStep?.reservationId = reservationId
        do {
            try await commitTheUpload()
            uploader.setStep(step: nextStep)
        } catch {
            uploader.setStep(step: failedStep)
            throw UploadError.uploadFailed
        }
    }
}
