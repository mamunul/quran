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

struct DocumentLink: Codable {
    var `self`: String
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
class GetAllPlatformVersionCommand {
//    GET https://api.appstoreconnect.apple.com/v1/apps/{id}/appStoreVersions

    struct AppStoreVersion {
        var type: String
        var id: String
    }

    /// actually providing all platforms (ios, macos, tvos) id for an app
    struct AppStoreVersionsResponse {
        var data: [AppStoreVersion]
        var links: DocumentLink
    }

    func execute() {
    }
}

class CreateNewLocalizationCommand {
    let method = "POST"
    let url = "https://api.appstoreconnect.apple.com/v1/appStoreVersionLocalizations"

    struct RelationshipData {
        var type: String
        var id: String
    }

    struct Attributes {
        var locale: String
        var description: String
        var keywords: String
        var marketingUrl: String
        var promotionalText: String
        var supportUrl: String
        var whatsNew: String
    }

    struct Relationships {
        var appStoreVersion: RelationshipData
    }

    struct RequestData {
        var type: String
        var attributes: Attributes
        var relationships: Relationships
    }

    struct LocalizationRequest {
        var data: RequestData
    }

    struct ResponseData {
        var type: String
        var attributes: Attributes
        var id: String
    }

    struct LocalizationResponse {
        var data: ResponseData
    }

    func execute() {
//        VersionLocalizationResponse

//        VersionLocalizationRequest
    }
}

class GetAllLocalizationsCommand {
    struct AppStoreVersionLocalization {
        var attributes: CreateNewLocalizationCommand.Attributes
        var id: String
        var links: DocumentLink
    }

    struct AppStoreVersionLocalizationsResponse {
        var data: [AppStoreVersionLocalization]

        var links: DocumentLink
    }

    func getAppStoreVersions() {
        /*
         GET https://api.appstoreconnect.apple.com/v1/appStoreVersions/{id}/appStoreVersionLocalizations
         */
    }
}

class GetALocalizationCommand {
    struct AppStoreVersionLocalizationResponse {
        var data: GetAllLocalizationsCommand.AppStoreVersionLocalization
        var included: [Any] // AppStoreVersion, AppScreenshotSet, AppPreviewSet
        var links: DocumentLink
    }

    func getViersionLocalization() {
        /*
         GET https://api.appstoreconnect.apple.com/v1/appStoreVersionLocalizations/{id}
         */

        /*

         Query :
         include
         [string]
         Possible values: appPreviewSets, appScreenshotSets, appStoreVersion
         */
    }
}

class DeleteALocalizationCommand {
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

struct ErrorResponse {
    struct Errors {
        /// (Required) A machine-readable code indicating the type of error. The code is a hierarchical value with levels of specificity separated by the '.' character. This value is parseable for programmatic   error handling in code.
        var code: String

        /// (Required) The HTTP status code of the error. This status code usually matches the response's status code; however, if the request produces multiple errors, these two codes may differ.
        var status: String

        /// The unique ID of a specific instance of an error, request, and response. Use this ID when providing feedback to or debugging issues with Apple.
        var id: String

        /// (Required) A summary of the error. Do not use this field for programmatic error handling.
        var title: String

        /// (Required) A detailed explanation of the error. Do not use this field for programmatic error handling.
        var detail: String
    }

    var error: [Errors]
}
