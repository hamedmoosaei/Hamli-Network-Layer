//
//  URLAndJSONParameterEncoder.swift
//  HamliNetworkLayerTests
//
//  Created by Hamed Moosaei on 1/11/23.
//

import Foundation

struct URLAndJSONParameterEncoding: ParameterEncoding {
    
    // MARK: Variable
    var urlParameter: Parameters
    var jsonParameter: Parameters
    
    // MARK: Function
    func encode(urlRequest: inout URLRequest) throws {
        
        guard let url = urlRequest.url else { throw ParameterEncodingError.missingURL }
        
        if var urlComponents = URLComponents(url: url,
                                             resolvingAgainstBaseURL: false), !urlParameter.isEmpty {
            
            urlComponents.queryItems = [URLQueryItem]()
            
            for (key, value) in urlParameter {
                let queryItem = URLQueryItem(name: key,
                                             value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                urlComponents.queryItems?.append(queryItem)
            }
            urlRequest.url = urlComponents.url
        }
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
