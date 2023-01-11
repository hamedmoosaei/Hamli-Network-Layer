//
//  JSONParameterEncodingUnitTest.swift
//  NetworkModuleUnitTest
//
//  Created by aliebrahimi on 3/12/22.
//

import XCTest
@testable import FarashenasaSDK

class JSONParameterEncodingUnitTest: XCTestCase {
    var sut: JSONParameterEncoding!
    var urlRequest: URLRequest!
    var jsonParameter: [String: Any]!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        jsonParameter = [
            "key1": "value1",
            "key2": "value2"
        ]
        sut = JSONParameterEncoding(jsonParameter: jsonParameter)
        urlRequest = URLRequest(url: URL(string: "https://test-offline.farashenasa.ir")!)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        urlRequest = nil
        try super.tearDownWithError()
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testEncodeWithForSetBodyParameter() {
        XCTAssertNoThrow(try sut.encode(urlRequest: &urlRequest), "must not throw any error in this state")
        XCTAssertEqual(urlRequest.httpBody, try JSONSerialization.data(withJSONObject: jsonParameter!, options: .prettyPrinted))
    }
    
    func testEncodeWithoutSetContentTypeHeader() {
        self.testEncodeWithForSetBodyParameter()
        XCTAssertEqual(urlRequest.value(forHTTPHeaderField: "Content-Type"), "application/json")
    }
    
    func testEncodeWithSetContentTypeHeader() {
        self.testEncodeWithForSetBodyParameter()
        urlRequest.setValue("Content-Type-value-test", forHTTPHeaderField: "Content-Type")
        XCTAssertEqual(urlRequest.value(forHTTPHeaderField: "Content-Type"), "Content-Type-value-test")
    }
}
