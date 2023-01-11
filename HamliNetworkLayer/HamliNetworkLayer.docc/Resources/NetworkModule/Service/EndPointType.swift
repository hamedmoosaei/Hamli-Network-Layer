//
//  EndPointType.swift
//  HamliNetworkLayerTests
//
//  Created by Hamed Moosaei on 1/11/23.
//

import Foundation
protocol EndPointType {

    /// The target's base `URL`.
    var baseURL: URL { get }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }

    /// The HTTP method used in the request.
    var httpMethod: HTTPMethod { get }

    /// Provides stub data for use in testing.
//    var sampleData: Data { get }

    /// The type of HTTP task to be performed.
    var task: HTTPTask { get }

    /// The type of validation to perform on the request. Default is `.none`.
//    var validationType: ValidationType { get }

    /// The headers to be used in the request.
    var headers: [String: String]? { get }
}
