//
//  GetAllPlatformVersionCommand.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 1/7/22.
//

import Foundation

struct AppStoreVersionAttributes: Codable {
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
    var attributes: AppStoreVersionAttributes
    var type: String
    var id: String
}

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
    private let method = Method.get

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

    func execute(appId: String, apiAccess: APIAccess) async throws -> AppStoreVersionsResponse {
        let request = Request(appId: appId)
        let urlString = "\(baseUrl)apps/\(request.appId)/appStoreVersions"
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        let response: AppStoreVersionsResponse = try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
        return response
    }
}

enum APIError: Error {
    case api(ErrorResponse)
}
