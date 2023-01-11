//
//  MultiPartParameterEncoder.swift
//  HamliNetworkLayerTests
//
//  Created by Hamed Moosaei on 1/11/23.
//

import Foundation

struct MultiPartParameterEncoding: ParameterEncoding {
    // MARK: Variable
    var multiPartParameter: [MultiParamTarget]
    
    // MARK: Function
    func encode(urlRequest: inout URLRequest) {
        var postData = Data()
        let boundary = "Boundary-\(UUID().uuidString)"
        for param in multiPartParameter {
            let paramName = param.key
            var line1 = "--\(boundary)\r\n"
            line1 += "Content-Disposition: form-data; name=\"\(paramName)\""
            postData.append(line1)
            switch param {
            case let .textType(_, value):
                let textLine = "\r\n\r\n\(value)\r\n"
                postData.append(textLine)
            case let .fileType(_, mimeType, src):
                let fileLine = "; filename=\"\(UserUtility.shared.uniqueKey).\(mimeType == .image_jpg ? "jpeg" : "mp4")\"\r\n"
                + "Content-Type: \(mimeType.rawValue)\r\n\r\n"
                postData.append(fileLine)
                postData.append(src)
                let endOfFileLine = "\r\n"
                postData.append(endOfFileLine)
            }
        }
        
        let lastLine = "--\(boundary)--"
        postData.append(lastLine)
        
        urlRequest.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = postData
        
    }
}

extension Data {
    mutating func append(_ string: String) {
        self.append(string.data(using: .utf8, allowLossyConversion: true) ?? Data())
    }
}
