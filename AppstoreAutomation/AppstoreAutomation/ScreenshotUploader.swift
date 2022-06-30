//
//  ScreenshotUploader.swift
//  AppstoreAutomation
//
//  Created by newone on 30/6/22.
//

import AppStoreConnect_Swift_SDK
import Foundation

class ScreenshotUploader {
    
    func dummy(configuration: APIConfiguration){
        let provider: APIProvider = APIProvider(configuration: configuration)

        let endpoint = APIEndpoint.apps(
            select: [.apps([.name]), .builds([.version, .processingState, .uploadedDate])],
            include: [.builds],
            sortBy: [.bundleIdAscending],
            limits: [.apps(1)])

        provider.request(endpoint) {
            switch $0 {
            case let .success(appsResponse):
                typealias BuildInfo = (uploadedDate: Date, version: String, processingState: String)
                guard
                    let app = appsResponse.data.first,
                    let name = app.attributes?.name,
                    let buildInfos = appsResponse.included?.compactMap({ included -> BuildInfo? in
                        if case let .build(build) = included,
                           let uploadedDate = build.attributes?.uploadedDate,
                           let version = build.attributes?.version,
                           let processingState = build.attributes?.processingState {
                            return (uploadedDate: uploadedDate, version: version, processingState: processingState)
                        }
                        return nil
                    }) else {
                    print("Could not find requested relationships!")
                    exit(EXIT_FAILURE)
                }

                print("App name is \(name)")
                print(" - successfully got \(buildInfos.count) builds included")
                for info in buildInfos.sorted(by: { $0.uploadedDate > $1.uploadedDate }) {
                    print("  - \(info.version): \(info.processingState)")
                }

                exit(EXIT_SUCCESS)
            case let .failure(error):
                print("Something went wrong fetching the apps: \(error)")
                exit(EXIT_FAILURE)
            }
        }
    }
    func upload(configuration: APIConfiguration) {
        let provider: APIProvider = APIProvider(configuration: configuration)

        let endpoint = APIEndpoint.apps(
            select: [.apps([.name]), .builds([.version, .processingState, .uploadedDate])],
            include: [.builds],
            sortBy: [.bundleIdAscending],
            limits: [.apps(1)])
        
//        APIEndpoint

        provider.request(endpoint) {
            switch $0 {
            case let .success(appsResponse):
                typealias BuildInfo = (uploadedDate: Date, version: String, processingState: String)
                guard
                    let app = appsResponse.data.first,
                    let name = app.attributes?.name,
                    let buildInfos = appsResponse.included?.compactMap({ included -> BuildInfo? in
                        if case let .build(build) = included,
                           let uploadedDate = build.attributes?.uploadedDate,
                           let version = build.attributes?.version,
                           let processingState = build.attributes?.processingState {
                            return (uploadedDate: uploadedDate, version: version, processingState: processingState)
                        }
                        return nil
                    }) else {
                    print("Could not find requested relationships!")
                    exit(EXIT_FAILURE)
                }

                print("App name is \(name)")
                print(" - successfully got \(buildInfos.count) builds included")
                for info in buildInfos.sorted(by: { $0.uploadedDate > $1.uploadedDate }) {
                    print("  - \(info.version): \(info.processingState)")
                }

                exit(EXIT_SUCCESS)
            case let .failure(error):
                print("Something went wrong fetching the apps: \(error)")
                exit(EXIT_FAILURE)
            }
        }
    }
}
