//
//  RouterUnitTest.swift
//  NetworkModuleUnitTest
//
//  Created by aliebrahimi on 3/26/22.
//

import XCTest
@testable import FarashenasaSDK

class RouterUnitTest: XCTestCase {
    fileprivate var sut: Router<TestRouterApi,BaseTestErrorModel>!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = Router<TestRouterApi,BaseTestErrorModel>()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    
    func testRequestInRange300To400() {
        let session = MockUrlSessionForResponseStatusCodeInRange300To400()
        sut.session = session
        let requestSuccessPromise = expectation(description: "must be success")
        sut.request(.getTest) { result in
            switch result {
            case .success:
                XCTFail("must not be success in this state")
                print("success")
            case .failure:
                print("error")
                requestSuccessPromise.fulfill()
                
            }
        }
        
        XCTAssertTrue(session.dataTask.resumeWasCalled)
        wait(for: [requestSuccessPromise], timeout: 2)
    }
    
    func testRequestInSuccessState() {
        let session = MockUrlSessionForSuccessState()
        sut.session = session
        let requestSuccessPromise = expectation(description: "must be success")
        sut.request(.getTest) { result in
            switch result {
            case .success:
                print("success")
                requestSuccessPromise.fulfill()
            case .failure:
                print("error")
                XCTFail("must not be failure in this state")
            }
        }
        
        XCTAssertTrue(session.dataTask.resumeWasCalled)
        wait(for: [requestSuccessPromise], timeout: 2)
    }
    
    func testRequestInRange400TO500() {
        let session = MockUrlSessionForResponseStatusCodeInRange400To500()
        sut.session = session
        let requestSuccessPromise = expectation(description: "must be success")
        sut.request(.getTest) { result in
            switch result {
            case .success:
                XCTFail("must not be success in this state")
                print("success")
            case .failure:
                print("error")
                requestSuccessPromise.fulfill()
                
            }
        }
        
        XCTAssertTrue(session.dataTask.resumeWasCalled)
        wait(for: [requestSuccessPromise], timeout: 2)
        
    }
    
    func testRequestWithOutNetworkConnection() {
        let session = MockURLSessionForWithOutNetworkConnection()
        sut.session = session
        let requestFailPromise = expectation(description: "must be fail")
        sut.request(.getTest) { result in
            switch result {
            case .success:
                print("success")
                XCTFail("must not be success without networkConnectionState")
            case let .failure(error):
                switch error {
                case .networkConnectionError:
                    requestFailPromise.fulfill()
                    print("success state in test")
                    break
                default:
                    XCTFail("must fail with just networkConnectionError")
                }
            }
        }
        
        XCTAssertTrue(session.dataTask.resumeWasCalled)
        wait(for: [requestFailPromise], timeout: 2)
    }
    
}

// MARK: Mock URLSessions
class MockUrlSessionForSuccessState: URLSessionProtocol {
    let dataTask = MockUrlSessionDataTask()
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        let range = 200...299
        let response = HTTPURLResponse(url: URL(string: "https://google.com")!, statusCode: Int.random(in: range), httpVersion: nil, headerFields: nil)
        let data = "test".data(using: .utf8)
        completionHandler(data, response, nil)
        return dataTask
    }
}

class MockUrlSessionForResponseStatusCodeInRange300To400: URLSessionProtocol {
    // MARK: Variable
    let dataTask = MockUrlSessionDataTask()
    // MARK: Function
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        let range = 300...399
        let response = HTTPURLResponse(url: URL(string: "https://google.com")!, statusCode: Int.random(in: range), httpVersion: nil, headerFields: nil)
        let data = "test".data(using: .utf8)
        completionHandler(data, response, nil)
        return dataTask
    }
}

class MockURLSessionForWithOutNetworkConnection: URLSessionProtocol {
    // MARK: Variable
    let dataTask = MockUrlSessionDataTask()
    // MARK: Function
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        let response: HTTPURLResponse? = nil
        let data = "no data".data(using: .utf8)
        completionHandler(data, response, nil)
        return dataTask
    }
}

class MockUrlSessionForResponseStatusCodeInRange400To500: URLSessionProtocol {
    // MARK: Variable
    let dataTask = MockUrlSessionDataTask()
    // MARK: Function
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        let range = 400...499
        let response = HTTPURLResponse(url: URL(string: "https://google.com")!, statusCode: Int.random(in: range), httpVersion: nil, headerFields: nil)
        let data = "test".data(using: .utf8)
        completionHandler(data, response, nil)
        return dataTask
    }
}


//MARK: URLSessionDataTask
class MockUrlSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false
    private (set) var cancelWasCalled = false
    
    func resume() {
        resumeWasCalled = true
    }
    
    func cancel() {
        cancelWasCalled = true
    }
}

// MARK: DataExtension
extension Data: RawRepresentable {
    public init?(rawValue: String) {
        self.init()
    }
    
    public var rawValue: String {
        return "data"
    }
}

// MARK: TestRouterApi
fileprivate enum TestRouterApi: EndPointType {
    case simplePostTest(data: String)
    case multiPartPostTest(data: Data)
    case getTest
    
    var baseURL: URL {
        return URL(string: "https://test-offline.farashenasa.ir")!
    }
    
    var path: String {
        return ""
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .simplePostTest, .multiPartPostTest:
            return .post
        case .getTest:
            return .get
        }
    }
    
    var task: HTTPTask {
        return .request
    }
    
    var headers: [String : String]? {
        return nil
    }
}

// MARK: Decodable Model
fileprivate struct BaseTestErrorModel: Decodable {
    var data: String
    var id: String
    
}
