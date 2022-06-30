//
//  APICommand.swift
//  AppstoreAutomation
//
//  Created by newone on 30/6/22.
//

import AppStoreConnect_Swift_SDK
import Foundation

protocol Response {
}

struct EmptyResponse: Response {
}

protocol Command {
    func execute<T: Response>() async throws -> T
}

class ScreenshotSetUploadCommand: Command {
    func execute<T: Response>() async throws -> T {
        EmptyResponse() as! T
    }
}

class ScreenshotUploadCommand {
}

class ScreenshotGetCommand {
}

class ScreennshotSetDeleteCommand {
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
