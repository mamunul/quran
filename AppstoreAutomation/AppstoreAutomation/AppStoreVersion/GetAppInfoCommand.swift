//
//  GetAppInfoCommand.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 2/7/22.
//

import Foundation

enum AppStoreVersionState: String, Codable {
    case DEVELOPER_REMOVED_FROM_SALE, DEVELOPER_REJECTED, IN_REVIEW, INVALID_BINARY, METADATA_REJECTED,
         PENDING_APPLE_RELEASE, PENDING_CONTRACT, PENDING_DEVELOPER_RELEASE, PREPARE_FOR_SUBMISSION,
         PREORDER_READY_FOR_SALE, PROCESSING_FOR_APP_STORE, READY_FOR_SALE, REJECTED, REMOVED_FROM_SALE,
         WAITING_FOR_EXPORT_COMPLIANCE, WAITING_FOR_REVIEW, REPLACED_WITH_NEW_VERSION, ACCEPTED, READY_FOR_REVIEW
}

class GetAppInfoCommand {
    let method = "GET"
    struct Request {
        var appId: String
    }

    struct Attributes: Codable {
        var appStoreState: AppStoreVersionState
    }

    struct AppInfo: Codable {
        var attributes: Attributes?
        var id: String
        var links: DocumentLink
        var type: String = "appInfos"
    }

    struct Response: Codable {
        var data: [AppInfo]
        var links: PagedDocumentLinks
    }

    func execute(request: Request, apiAccess: APIAccess) async throws -> Response {
        let urlString = "https://api.appstoreconnect.apple.com/v1/apps/\(request.appId)/appInfos"
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        let response: Response = try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
        return response
    }
}
