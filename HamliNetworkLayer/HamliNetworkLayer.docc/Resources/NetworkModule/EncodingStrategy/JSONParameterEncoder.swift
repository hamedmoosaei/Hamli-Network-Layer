//
//  JSONParameterEncoder.swift
//  HamliNetworkLayerTests
//
//  Created by Hamed Moosaei on 1/11/23.
//

import Foundation

struct JSONParameterEncoding: ParameterEncoding {
    
    // MARK: Variable
    var jsonParameter: Parameters
    
    // MARK: Function
    func encode(urlRequest: inout URLRequest) throws {
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: jsonParameter, options: .prettyPrinted)
            urlRequest.httpBody = jsonAsData
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        } catch {
            throw ParameterEncodingError.encodingFailed
        }
    }
}
