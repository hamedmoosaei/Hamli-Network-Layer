//
//  ParameterEncoding.swift
//  HamliNetworkLayerTests
//
//  Created by Hamed Moosaei on 1/11/23.
//

import Foundation

typealias Parameters = [String: Any]

protocol ParameterEncoding {
    func encode(urlRequest: inout URLRequest) throws
}

enum ParameterEncodingError: String, Error {
    case parametersNil = "Parameters were nil."
    case encodingFailed = "Parameter encoding failed."
    case missingURL = "URL is nil."
}

enum MultiParamTarget {
    case textType(key: String, value: String)
    case fileType(key: String, mimeType: MimeType, src: Data)
    
    var key: String {
        switch self {
        case let .fileType(fileKey, _, _):
            return fileKey
        case let .textType(textKey, _):
            return textKey
        }
    }
}

enum MimeType: String {
    case image_jpg = "image/jpeg"
    case video_mp4 = "video/mp4"
}
