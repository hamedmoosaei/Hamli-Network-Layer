//
//  URLAndJSONParameterEncodingUnitTest.swift
//  NetworkModuleUnitTest
//
//  Created by aliebrahimi on 3/15/22.
//

import XCTest
@testable import FarashenasaSDK

class URLAndJSONParameterEncodingUnitTest: XCTestCase {
    
    var sut: URLAndJSONParameterEncoding!
    var urlRequest: URLRequest!
    var jsonParameter: [String: Any]!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        jsonParameter = [
            "key1": "value1",
            "key2": "value2"
        ]
        sut = URLAndJSONParameterEncoding(urlParameter: [
            "urlkey1":"urlvalue1",
            "urlkey2":"urlvalue2"
        ], jsonParameter: jsonParameter)
        urlRequest = URLRequest(url: URL(string: "https://test-offline.farashenasa.ir")!)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
    
    func testEncodeWithNilUrl() {
        urlRequest.url = nil
        XCTAssertThrowsError(
            try sut.encode(urlRequest: &urlRequest),"this test with nil url must throw an error") { (errorThrown) in
                XCTAssertEqual(errorThrown as? ParameterEncodingError, ParameterEncodingError.missingURL, "the error must be missingURLError")
        }
    }
    
    func testQuerytItemsAreSetForUrlRequest() {
        XCTAssertNoThrow(try sut.encode(urlRequest: &urlRequest), "this test must not throw error")
        let urlComponent = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: false)
        XCTAssertNotNil(urlComponent?.queryItems)
        XCTAssertEqual(urlComponent?.queryItems?.count, 2)
        
        let valueOfKey1 = urlComponent?.queryItems?.first { item in
            item.name == "urlkey1"
        }
        let valueOfKey2 = urlComponent?.queryItems?.first { item in
            item.name == "urlkey2"
        }
        
        XCTAssertEqual(valueOfKey1?.value, "urlvalue1")
        XCTAssertEqual(valueOfKey2?.value, "urlvalue2")
    }
    
    func testEncodeWithoutSetContentTypeHeader() {
        self.testQuerytItemsAreSetForUrlRequest()
        XCTAssertEqual(urlRequest.value(forHTTPHeaderField: "Content-Type"), "application/json")
    }
    
    func testEncodeWithSetContentTypeHeader() {
        self.testQuerytItemsAreSetForUrlRequest()
        urlRequest.setValue("Content-Type", forHTTPHeaderField: "Content-Type")
        XCTAssertEqual(urlRequest.value(forHTTPHeaderField: "Content-Type"), "Content-Type")
    }

    func testEncodeWithForSetBodyParameter() {
        XCTAssertNoThrow(try sut.encode(urlRequest: &urlRequest), "must not throw any error in this state")
        XCTAssertEqual(urlRequest.httpBody, try JSONSerialization.data(withJSONObject: jsonParameter!, options: .prettyPrinted))
    }

}
