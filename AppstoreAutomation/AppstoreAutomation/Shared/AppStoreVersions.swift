//
//  APICommand.swift
//  AppstoreAutomation
//
//  Created by newone on 30/6/22.
//

import Foundation


protocol Command {
    /// - Parameters:
    ///    - request: get/post data
    ///    - apiAccess: api access secret keys
    ///
    /// - Returns: return json type
//    func execute<T: Response>(request: Request, apiAccess: APIAccess) async throws -> T
}



class APICommand {
    func execute() async throws {
        let url: URL = URL(string: "")!
        var urlRequest = URLRequest(url: url)
        let authorizationToken = ""
        urlRequest.httpMethod = Method.post.rawValue
        urlRequest.setValue("Bearer \(authorizationToken)", forHTTPHeaderField: "Authorization")

        let response = try await URLSession.shared.data(for: urlRequest)

        print(response)
    }
}

