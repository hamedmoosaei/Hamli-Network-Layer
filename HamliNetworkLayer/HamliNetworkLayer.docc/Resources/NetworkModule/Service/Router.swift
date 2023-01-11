//
//  Router.swift
//  HamliNetworkLayerTests
//
//  Created by Hamed Moosaei on 1/11/23.
//

import Foundation

internal typealias NetworkRouterCompletion<U: Decodable> = (_ result: Result<Data, NetworkError<U>>) -> Void
internal typealias NetworkRouterResult<T: Decodable> = Result<Data, NetworkError<T>>

protocol NetworkRouter: AnyObject {
    associatedtype EndPoint: EndPointType
    associatedtype ErrorDecodableModel: Decodable
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion<ErrorDecodableModel>)
    func cancel()
}

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
    func cancel()
}

extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }

class Router<EndPoint: EndPointType, ErrorModelType: Decodable>: NSObject, URLSessionDelegate, NetworkRouter {
    private var task: URLSessionDataTaskProtocol?
    var session: URLSessionProtocol?
    
    override init() {
        super.init()
        session = URLSession(configuration: .ephemeral, delegate: self, delegateQueue: nil)
    }
    
    //
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        // Trust the certificate even if not valid
        let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        
        completionHandler(.useCredential, urlCredential)
    }
    
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion<ErrorModelType>) {
        
        do {
            let request = try self.buildRequest(from: route)
            task = session?.dataTask(with: request, completionHandler: {[weak self] data, response, _ in
                guard let _self = self else { return }
                let result = _self.handleNetworkResponse(response: response, data: data)
                completion(result)
            })
        } catch {
            completion(.failure(NetworkError.URLSessionError(error.localizedDescription)))
        }
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 40.0)
        
        request.httpMethod = route.httpMethod.rawValue
        do {
            self.addAdditionalHeaders(route.headers, request: &request)
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParameters(let bodyEncoding):
                
                try self.configureParameters(bodyEncoding: bodyEncoding,
                                             request: &request)
                
            case .requestParametersAndHeaders(let bodyEncoding,
                                              let additionalHeaders):
                
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(bodyEncoding: bodyEncoding,
                                             request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyEncoding: ParameterEncoding,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request)
        } catch {
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    fileprivate func handleNetworkResponse(response: URLResponse?, data: Data?) -> NetworkRouterResult<ErrorModelType> {
        guard let response = response as? HTTPURLResponse else { return .failure(.networkConnectionError)}
        guard let data = data else { return .failure(.noData)}
        return checkResponseStatuseCode(data: data, response: response)
    }
    
    fileprivate func checkResponseStatuseCode(data: Data, response: HTTPURLResponse) -> NetworkRouterResult<ErrorModelType> {
        switch response.statusCode {
        case 200...299:
            return .success(data)
        case 400...500:
            return .failure(.responseError(data: ErrorResponseData(data: data)))
        case 501...599:
            return .failure(.serverErrror)
        case 600:
            return .failure(.outDated)
        default:
            return .failure(.URLSessionError("Unknowned error"))
        }
    }
}
