//
//  APICommand.swift
//  AppstoreAutomation
//
//  Created by newone on 30/6/22.
//

import Foundation

protocol Response {
}

struct EmptyResponse: Response {
}

protocol Command {
    /// - Return :
    func execute<T: Response>() async throws -> T
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
class AllPlatformsGetCommand {
//    GET https://api.appstoreconnect.apple.com/v1/apps/{id}/appStoreVersions

    struct AppStoreVersion {
        var type: String
        var id: String
    }

    struct PagedDocumentLinks: Codable {
        var ss: String

        enum CodingKeys: String, CodingKey {
            case ss = "self"
        }
    }

    /// actually providing all platforms (ios, macos, tvos) id for an app
    struct AppStoreVersionsResponse {
        var data: [AppStoreVersion]
        var links: PagedDocumentLinks
    }

    func execute() {
    }
}

class NewLocalizationCreateCommand {
    let method = "POST"
    let url = "https://api.appstoreconnect.apple.com/v1/appStoreVersionLocalizations"
    struct VersionLocalizationAttributes {
        var locale: String
        var description: String
        var keywords: String
        var marketingUrl: String
        var promotionalText: String
        var supportUrl: String
        var whatsNew: String
    }

    struct VersionRelationshipData {
        var type: String
        var id: String
    }

    struct VersionRelationships {
        var appStoreVersion: VersionRelationshipData
    }

    struct VersionLocalizationData {
        var type: String
        var attributes: VersionLocalizationAttributes
        var relationships: VersionRelationships
    }

    struct VersionLocalizationRequest {
        var data: VersionLocalizationData
    }

    struct VersionLocalizationResponseData {
        var type: String
        var attributes: VersionLocalizationAttributes
        var id: String
    }

    struct VersionLocalizationResponse {
        var data: VersionLocalizationResponseData
    }

    func execute() {
//        VersionLocalizationResponse

//        VersionLocalizationRequest
    }
}

class AllVersionLocalizationsGetCommand {
    struct AppStoreVersionLocalization {
        var attributes: NewLocalizationCreateCommand.VersionLocalizationAttributes
        var id: String
        var links: AllPlatformsGetCommand.PagedDocumentLinks
    }

    struct AppStoreVersionLocalizationsResponse {
        var data: [AppStoreVersionLocalization]

        var links: AllPlatformsGetCommand.PagedDocumentLinks
    }

    func getAppStoreVersions() {
        /*
         GET https://api.appstoreconnect.apple.com/v1/appStoreVersions/{id}/appStoreVersionLocalizations
         */
    }
}

class AVersionLocalizationGetCommand {
    struct AppStoreVersionLocalizationResponse {
        var data: AllVersionLocalizationsGetCommand.AppStoreVersionLocalization

        var links: AllPlatformsGetCommand.PagedDocumentLinks
    }
    func getViersionLocalization() {
        /*
         GET https://api.appstoreconnect.apple.com/v1/appStoreVersionLocalizations/{id}
         */
    }
}

class AVersionLocalizationDeleteCommand {
    func deleteVersionLocalization() {
        /*
         DELETE https://api.appstoreconnect.apple.com/v1/appStoreVersionLocalizations/{id}
         */
    }
}

class APICommand {
    func execute() async throws {
        let url: URL = URL(string: "")!
        var urlRequest = URLRequest(url: url)
        let authorizationToken = ""
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(authorizationToken)", forHTTPHeaderField: "Authorization")

        let response = try await URLSession.shared.data(for: urlRequest)

        print(response)
    }
}

/*

{
    "errors": [{
        "status": "401",
        "code": "NOT_AUTHORIZED",
        "title": "Authentication credentials are missing or invalid.",
        "detail": "Provide a properly configured and signed bearer token, and make sure that it has not expired. Learn more about Generating Tokens for API Requests https://developer.apple.com/go/?id=api-generating-tokens"
    }]

}
*/
