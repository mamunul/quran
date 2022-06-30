//
//  ConnectAuthorization.swift
//  AppstoreAutomation
//
//  Created by newone on 30/6/22.
//

import CoreMedia
import CryptoKit
import Foundation

struct JWTHeader: Codable {
    /// - Encryption Algorithm ES256; All JWTs for App Store Connect API must be signed with ES256 encryption
    var alg: String
    /// - Key Identifier; Your private key ID from App Store Connect; for example 2X9R4HXF34.
    var kid: String
    /// - Token Type
    var typ: String
}

struct JWTPayload: Codable {
    /// - Issuer ID;Your issuer ID from the API Keys page in App Store Connect; for example, 57246542-96fe-1a63-e053-0824d011072a.
    var iss: String
    /// - Issued At Time;The token’s creation time, in UNIX epoch time; for example, 1528407600.
    var iat: String
    /// - Expiration Time;The token’s expiration time in Unix epoch time. Tokens that expire more than 20 minutes into the future are not valid except for resources listed in Determine the Appropriate Token Lifetime.
    var exp: String
    /// - Audience;appstoreconnect-v1
    var aud: String
    /// - Token Scope;A list of operations you want App Store Connect to allow for this token; for example, GET /v1/apps/123. (Optional)
    var scope: [String]
}

class AuthorizationTokenGenerator {
    // https://developer.apple.com/documentation/appstoreconnectapi/generating_tokens_for_api_requests
    private func createJWTHeader() -> JWTHeader {
        JWTHeader(alg: "ES256", kid: "", typ: "JWT")
        /*
         JWT {
             "alg": "ES256",
                 "kid": "2X9R4HXF34",
                 "typ": "JWT"
         }
          */
    }

    private func createJWTPayload() -> JWTPayload {
        let intervalInMinute: UInt64 = 10 * 1000 * 60
        let issuedTime = UInt64(floor(Date().timeIntervalSince1970 * 1000))
        let expiredTime = issuedTime + intervalInMinute

        let scope = [
            "POST /v1/appScreenshots",
            "POST /v1/appScreenshotSets",
            "DELETE /v1/appScreenshotSets",
        ]

        let payload =
            JWTPayload(
                iss: "",
                iat: "\(issuedTime)",
                exp: "\(expiredTime)",
                aud: "appstoreconnect-v1",
                scope: scope
            )
        return payload
        /*

         {
             "iss": "57246542-96fe-1a63-e053-0824d011072a",
             "iat": 1528407600,
             "exp": 1528408800,
             "aud": "appstoreconnect-v1",
             "scope": [
                 "GET /v1/apps?filter[platform]=IOS",
                 "POST /v1/appScreenshots",
                "POST /v1/appScreenshotSets",
                "DELETE /v1/appScreenshotSets"
             ]
         }

         */
    }

    func generateToken() -> String {
        let secret = "your-256-bit-secret"
        let privateKey = SymmetricKey(data: Data(secret.utf8))

        let headerJSONData = try! JSONEncoder().encode(createJWTHeader())
        let headerBase64String = headerJSONData.base64EncodedString()

        let payloadJSONData = try! JSONEncoder().encode(createJWTPayload())
        let payloadBase64String = payloadJSONData.base64EncodedString()

        let toSign = Data((headerBase64String + "." + payloadBase64String).utf8)

        let signature = HMAC<SHA256>.authenticationCode(for: toSign, using: privateKey)
        let signatureBase64String = Data(signature).base64EncodedString()

        let token = [headerBase64String, payloadBase64String, signatureBase64String].joined(separator: ".")
        print(token) // eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c

        return token
    }
}
