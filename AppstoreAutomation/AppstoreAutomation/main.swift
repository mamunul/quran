//
//  main.swift
//  AppstoreAutomation
//
//  Created by newone on 30/6/22.
//

import Foundation

print("Hello, World!")

/// Go to https://appstoreconnect.apple.com/access/api and create your own key. This is also the page to find the private key ID and the issuer ID.
/// Download the private key and open it in a text editor. Remove the line breaks from the private key string and copy the contents over to the private key parameter.

AuthorizationTokenGenerator().generateToken()
