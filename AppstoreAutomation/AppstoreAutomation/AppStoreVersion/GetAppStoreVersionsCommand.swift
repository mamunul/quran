//
//  GetAllPlatformVersionCommand.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 1/7/22.
//

import Foundation

///
/// Command to get the id of the avialable platform for an app
///
/// Provide an app _id_ in the  __GET__  request it will send response with the each platorm info id in return.
/// This class conforms with ``Command`` _protocol_
/// ```swift
/////usage
/// AllPlatformsGetCommand().execute()
///
/// ```
class GetAppStoreVersionsCommand {
    let method = "GET"

    enum ReleaseType: String, Codable {
        case MANUAL, AFTER_APPROVAL, SCHEDULED
    }

    enum Platform: String, Codable {
        case IOS, MAC_OS, TV_OS
    }

    enum AppStoreVersionState: String, Codable {
        case DEVELOPER_REMOVED_FROM_SALE, DEVELOPER_REJECTED, IN_REVIEW, INVALID_BINARY, METADATA_REJECTED
        case PENDING_APPLE_RELEASE, PENDING_CONTRACT, PENDING_DEVELOPER_RELEASE, PREPARE_FOR_SUBMISSION
        case PREORDER_READY_FOR_SALE, PROCESSING_FOR_APP_STORE, READY_FOR_SALE, REJECTED, REMOVED_FROM_SALE
        case WAITING_FOR_EXPORT_COMPLIANCE, WAITING_FOR_REVIEW, REPLACED_WITH_NEW_VERSION
        case ACCEPTED, READY_FOR_REVIEW
    }

    struct PlatformAttributes: Codable {
        var platform: Platform
        var appStoreState: AppStoreVersionState
        var copyright: String?
        var earliestReleaseDate: String?
        var releaseType: ReleaseType

        var versionString: String
        var createdDate: String
        var downloadable: Bool
    }

    struct AppStoreVersion: Codable {
        var attributes: PlatformAttributes
        var type: String
        var id: String
    }

    struct Request {
        static var empty: Request = Request(appId: "")
        static var quranApp = Request(appId: "1632370801")

        var appId: String
    }

    /// actually providing all platforms (ios, macos, tvos) id for an app
    struct AppStoreVersionsResponse: Codable {
        var data: [AppStoreVersion]
        var links: DocumentLink
    }

    func execute(request: Request, apiAccess: APIAccess) async throws -> AppStoreVersionsResponse {
        let urlString = "https://api.appstoreconnect.apple.com/v1/apps/\(request.appId)/appStoreVersions"
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        let response: AppStoreVersionsResponse = try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
        return response
    }
}

enum APIError: Error {
    case api(ErrorResponse)
}
