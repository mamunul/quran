//
//  main.swift
//  AppstoreAutomation
//
//  Created by newone on 30/6/22.
//

import Foundation

let api = APIAccess(secret: secret, issuerID: issuerID, apiKey: apiKey, bundleId: bundleId, baseUrl: baseUrl)
let facade = AppstoreConnectFacade()
facade.configure(apiAccess: api)

//testUploadScreenshot()
// testModifyAppStoreVersionLocalizedAPI()
// testModifyAppInfoVersionAPI()
// testGetApi(facade: facade)
// testCreateALocalizationAPI(facade: facade)
RunLoop.main.run()
