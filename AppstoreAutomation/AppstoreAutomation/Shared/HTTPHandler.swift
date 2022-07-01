//
//  HTTPHandler.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 1/7/22.
//

import Foundation

class HTTPHandler {
    func execute<T: Codable>(urlRequest: URLRequest, access: APIAccess) async throws -> T {
        var request = urlRequest
        let access = APIAccess(secret: access.secret, issuerID: access.issuerID, apiKey: access.apiKey)
        let token = try AuthTokenGenerator().generateToken(apiAccess: access)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let (data, response) = try await URLSession.shared.data(for: request)

        let decoder = JSONDecoder()

        if (response as! HTTPURLResponse).statusCode == 200 {
            let result = try decoder.decode(T.self, from: data)
            return result
        } else {
            let result = try decoder.decode(ErrorResponse.self, from: data)
            throw APIError.api(result)
        }
    }
}
