//
//  HTTPTask.swift
//  HamliNetworkLayerTests
//
//  Created by Hamed Moosaei on 1/11/23.
//

import Foundation

typealias HTTPHeaders = [String: String]

enum HTTPTask {
    case request
    
    case requestParameters(bodyEncoding: ParameterEncoding)
    
    case requestParametersAndHeaders(bodyEncoding: ParameterEncoding, additionHeaders: HTTPHeaders? = nil)
    
    // case download, upload...etc
}
