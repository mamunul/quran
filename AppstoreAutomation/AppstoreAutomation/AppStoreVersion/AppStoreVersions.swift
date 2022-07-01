//
//  APICommand.swift
//  AppstoreAutomation
//
//  Created by newone on 30/6/22.
//

import Foundation

protocol Response: Codable {
    static var empty: Response { get }
}

protocol Request: Codable {
    static var empty: Request { get }
}

struct EmptyResponse: Response {
    static var empty: Response = EmptyResponse()
}

protocol Command {
    /// - Parameters:
    ///    - request: get/post data
    ///    - apiAccess: api access secret keys
    ///
    /// - Returns: return json type
    func execute<T: Response>(request: Request, apiAccess: APIAccess) async throws -> T
}

struct DocumentLink: Codable {
    var `self`: String
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

struct ErrorResponse: Codable {
    struct Errors: Codable {
        /// (Required) A machine-readable code indicating the type of error. The code is a hierarchical value with levels of specificity separated by the '.' character. This value is parseable for programmatic   error handling in code.
        var code: String

        /// (Required) The HTTP status code of the error. This status code usually matches the response's status code; however, if the request produces multiple errors, these two codes may differ.
        var status: String

        /// The unique ID of a specific instance of an error, request, and response. Use this ID when providing feedback to or debugging issues with Apple.
        var id: String?

        /// (Required) A summary of the error. Do not use this field for programmatic error handling.
        var title: String

        /// (Required) A detailed explanation of the error. Do not use this field for programmatic error handling.
        var detail: String
    }

    var errors: [Errors]
}
