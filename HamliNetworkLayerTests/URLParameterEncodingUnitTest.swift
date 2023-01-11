//
//  NetworkModuleUnitTest.swift
//  NetworkModuleUnitTest
//
//  Created by aliebrahimi on 3/12/22.
//

import XCTest
@testable import FarashenasaSDK

class URLParameterEncodingUnitTest: XCTestCase {
    
    var sut: URLParameterEncoding!
    var urlRequest: URLRequest!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = URLParameterEncoding(urlParameter: [
            "key1":"value1",
            "key2":"value2"
        ])
        urlRequest = URLRequest(url: URL(string: "https://test-offline.farashenasa.ir")!)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
        urlRequest = nil
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
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
            item.name == "key1"
        }
        let valueOfKey2 = urlComponent?.queryItems?.first { item in
            item.name == "key2"
        }
        
        XCTAssertEqual(valueOfKey1?.value, "value1")
        XCTAssertEqual(valueOfKey2?.value, "value2")
    }
    
    func testEncodeWithoutSetContentTypeHeader() {
        self.testQuerytItemsAreSetForUrlRequest()
        XCTAssertEqual(urlRequest.value(forHTTPHeaderField: "Content-Type"), "application/x-www-form-urlencoded; charset=utf-8")
    }
    
    func testEncodeWithSetContentTypeHeader() {
        self.testQuerytItemsAreSetForUrlRequest()
        urlRequest.setValue("Content-Type", forHTTPHeaderField: "Content-Type")
        XCTAssertEqual(urlRequest.value(forHTTPHeaderField: "Content-Type"), "Content-Type")
    }
    

}

