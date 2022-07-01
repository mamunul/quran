//
//  Screenshots.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 30/6/22.
//

import Foundation

class CreateScreenshotSetCommand: Command {
    /*
     POST https://api.appstoreconnect.apple.com/v1/appScreenshotSets
     */
    struct RequestData {
        var attributes: GetScreenshotSetsCommand.Attributes
        var type: String
    }

    struct AppScreenshotSetRequest {
        var data: RequestData
    }

    func execute<T: Response>() async throws -> T {
        EmptyResponse() as! T
    }
}

struct PagedDocumentLinks {
    var first: String
    var next: String
    var `self`: String
}
