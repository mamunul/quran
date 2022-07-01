//
//  ScreenshotUploader.swift
//  AppstoreAutomation
//
//  Created by newone on 30/6/22.
//

import Foundation

protocol IUploadable {
    func makeAnUploadRequest()
    func uploadTheAsset()
    func commitTheUpload()
    func verifyUpload()
}

extension IUploadable { // Template Method
    func upload() {
        makeAnUploadRequest()
        uploadTheAsset()
        commitTheUpload()
        verifyUpload()
    }
}

class ScreenshotUploader: IUploadable {
    func makeAnUploadRequest() {
    }

    func uploadTheAsset() {
    }

    func commitTheUpload() {
    }

    func verifyUpload() {
    }
}
