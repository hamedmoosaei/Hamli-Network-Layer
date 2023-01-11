//
//  URLParameterEncoder.swift
//  HamliNetworkLayerTests
//
//  Created by Hamed Moosaei on 1/11/23.
//

import Foundation

struct URLParameterEncoding: ParameterEncoding {
    
    // MARK: Variable
    var urlParameter: Parameters
    
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
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
    }
}
