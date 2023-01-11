//
//  NetworkError.swift
//  HamliNetworkLayerTests
//
//  Created by Hamed Moosaei on 1/11/23.
//

import Foundation
import UIKit

protocol PartNetworkLayerError {
    
}

enum NetworkError<ErrorModelType>: Error where ErrorModelType: Decodable {
    case noData
    case unableToDecode
    case URLSessionError(String)
    case responseError(data: ErrorResponseData<ErrorModelType>)
    case networkConnectionError
    case serverErrror
    case outDated
}

struct ErrorResponseData<DataModel: Decodable> {
    var data: Data
    
    func dataModel() -> Result<DataModel, NetworkError<DataModel>> {
        do {
            let tempModel = try JSONDecoder().decode(DataModel.self, from: self.data)
            return .success(tempModel)
        } catch {
            return .failure(.unableToDecode)
        }
        
    }
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noData:
            return "No Data"
        case .unableToDecode:
            return "Unable To Decode"
        case .URLSessionError(let str):
            return str
        case .responseError(_):
            return "Bad Request"
        case .networkConnectionError:
            return "some problem occured in connection"
        case .serverErrror:
            return "some problem occured in server"
        case .outDated:
            return "out dated"
        }
    }
}
