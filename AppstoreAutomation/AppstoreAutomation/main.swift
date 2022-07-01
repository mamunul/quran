//
//  main.swift
//  AppstoreAutomation
//
//  Created by newone on 30/6/22.
//

import Foundation

print("Hello, World!")

let secret =
    """
    -----BEGIN PRIVATE KEY-----
    MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgVnOT7sOOOGkQMQV7
    miW9HQeMvnpeFgd8WcDrtTyOC3WgCgYIKoZIzj0DAQehRANCAARAi6tlmvjUoR8J
    kuJllx99tL3ql1r/JlDLTSQkJEmq3SCehgkflJcFqzW3S+k4At/ylzikYXkV6GeK
    H6unezm1
    -----END PRIVATE KEY-----
    """
let issuerID = "fc8ed846-b97d-47e0-b3c7-4570c073cbd6"
let apiKey = "76CUBSK6L4"

let token = try? AuthTokenGenerator().generateToken(secret: secret, issuerID: issuerID, apiKey: apiKey)
print(token)

let command =
    """
    curl -v -H 'Authorization: Bearer \(token)'  "https://api.appstoreconnect.apple.com/v1/apps"
    """

print(command)

// curl -v -H 'Authorization: Bearer '  "https://api.appstoreconnect.apple.com/v1/apps"
