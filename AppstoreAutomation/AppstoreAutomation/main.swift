//
//  main.swift
//  AppstoreAutomation
//
//  Created by newone on 30/6/22.
//

import Foundation

struct APIAccess {
    var secret: String
    var issuerID: String
    var apiKey: String
}

func testApi() {
    let api = APIAccess(secret: secret, issuerID: issuerID, apiKey: apiKey)
    let request = GetAllPlatformVersionCommand.GetAllPlatformRequest(appId: "1632370801")
    Task {
        do {
            let response = try await GetAllPlatformVersionCommand().execute(request: request, apiAccess: api)
            print(response)
        } catch {
            print(error)
        }
    }

//    GetAllPlatformVersionCommand().execute(request: <#T##Request#>, apiAccess: api)
}

testApi()
RunLoop.main.run()
