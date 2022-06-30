//
//  Screenshots.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 30/6/22.
//

import Foundation

class ScreenshotSetUploadCommand: Command {
    /*
     POST https://api.appstoreconnect.apple.com/v1/appScreenshotSets
     */
    func execute<T: Response>() async throws -> T {
        EmptyResponse() as! T
    }
}

class ScreenshotUploadCommand {

}

class ScreenshotGetCommand {
    /*
     GET https://api.appstoreconnect.apple.com/v1/appScreenshotSets/{id}
     */
}

class ScreennshotSetDeleteCommand {
    /*
     DELETE https://api.appstoreconnect.apple.com/v1/appScreenshotSets/{id}
     */
}

