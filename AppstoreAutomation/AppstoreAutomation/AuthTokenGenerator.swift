//
//  ConnectAuthorization.swift
//  AppstoreAutomation
//
//  Created by newone on 30/6/22.
//

import CoreMedia
import CryptoKit
import Foundation
import SwiftJWT

struct JWTHeader: Codable {
    ///  Encryption Algorithm ES256; All JWTs for App Store Connect API must be signed with ES256 encryption
    var alg: String
    ///  Key Identifier; Your private key ID from App Store Connect; for example 2X9R4HXF34.
    var kid: String
    ///  Token Type
    var typ: String
}

/// this is the payload of token generation
struct JWTPayload: Codable {
    ///  Issuer ID;Your issuer ID from the API Keys page in App Store Connect; for example, 57246542-96fe-1a63-e053-0824d011072a.
    var iss: String
    ///  Issued At Time;The token’s creation time, in UNIX epoch time; for example, 1528407600.
    var iat: String
    ///  Expiration Time;The token’s expiration time in Unix epoch time. Tokens that expire more than 20 minutes into the future are not valid except for resources listed in Determine the Appropriate Token Lifetime.
    var exp: String
    ///  Audience;appstoreconnect-v1
    var aud: String
    ///  Token Scope;A list of operations you want App Store Connect to allow for this token; for example, GET /v1/apps/123. (Optional)
    var scope: [String]
}

/// Go to https://appstoreconnect.apple.com/access/api and create your own key. This is also the page to find the private key ID and the issuer ID.
/// Download the private key and open it in a text editor. Remove the line breaks from the private key string and copy the contents over to the private key parameter.
class AuthTokenGenerator {
    // https://developer.apple.com/documentation/appstoreconnectapi/generating_tokens_for_api_requests
    private func createJWTHeader(key: String) -> JWTHeader {
        JWTHeader(alg: "ES256", kid: key, typ: "JWT")
    }

    private func createJWTPayload(issuerID: String) -> JWTPayload {
        let intervalInMinute: UInt64 = 10 * 1000 * 60
        let issuedTime = UInt64(floor(Date().timeIntervalSince1970 * 1000))
        let expiredTime = issuedTime + intervalInMinute

        let readScope = [
            "GET /v1/appScreenshots",
            "GET /v1/appStoreVersionLocalizations",
            "GET /v1/appStoreVersions",
            "GET /v1/apps",
        ]

        let payload =
            JWTPayload(
                iss: issuerID,
                iat: "\(issuedTime)",
                exp: "\(expiredTime)",
                aud: "appstoreconnect-v1",
                scope: readScope
            )
        return payload
    }

    /// This method will generate token for accessing app store connect api
    ///
    /// - Parameter secret: Private key taken from app store connect website
    func generateToken(secret: String, issuerID: String, apiKey: String) -> String {
        let privateKeyData = Data(secret.utf8)
        let privateKey = SymmetricKey(data: privateKeyData)

        let headerJSONData = try! JSONEncoder().encode(createJWTHeader(key: apiKey))
        let headerBase64String = headerJSONData.base64EncodedString()

        let payloadJSONData = try! JSONEncoder().encode(createJWTPayload(issuerID: issuerID))
        let payloadBase64String = payloadJSONData.base64EncodedString()

        let toSign = Data((headerBase64String + "." + payloadBase64String).utf8)
        
//        let jwtSigner = JWTSigner.es256(privateKey: privateKey.)
//
//        let signedJWT = try myJWT.sign(using: jwtSigner)

        let signature = HMAC<SHA256>.authenticationCode(for: toSign, using: privateKey)
        let signatureBase64String = Data(signature).base64EncodedString()

        let token = [headerBase64String, payloadBase64String, signatureBase64String].joined(separator: ".")

        return token
    }
}
