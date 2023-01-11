//
//  MultipartparameterencodingUnitTest.swift
//  NetworkModuleUnitTest
//
//  Created by aliebrahimi on 3/13/22.
//

import XCTest
@testable import FarashenasaSDK

class MultipartParameterencodingUnitTest: XCTestCase {
    var sut: MultiPartParameterEncoding!
    var urlRequest: URLRequest!
    var multiPartParameter: [MultiParamTarget]!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        multiPartParameter = []
        sut = MultiPartParameterEncoding(multiPartParameter: multiPartParameter)
        urlRequest = URLRequest(url: URL(string: "https://test-offline.farashenasa.ir")!)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        urlRequest = nil
        sut = nil
        try super.tearDownWithError()
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testEncodeWithEmptyMultiPartParameter() {
        sut.multiPartParameter = [
            .fileType(key: "signature", mimeType: .image_jpg, src: Data()),
            .textType(key: "uniqueKey", value: "UserUtility.shared.uniqueKey"),
        ]
        
        sut.encode(urlRequest: &urlRequest)
//        XCTAssertEqual(String(data: urlRequest.httpBody!, encoding: .utf8), "")
    }
    
    func testEncodeWithTextType() {
        
    }
    
    func testEncodeWithFileType() {
        
    }
    

}
