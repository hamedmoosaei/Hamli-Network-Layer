//
//  NetworkErrorUnitTest.swift
//  NetworkModuleUnitTest
//
//  Created by aliebrahimi on 3/17/22.
//

import XCTest
@testable import FarashenasaSDK

class NetworkErrorUnitTest: XCTestCase {
    fileprivate var sut: ErrorResponseData<TestDataModel>!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = ErrorResponseData(data: Data())
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
    
    func testDataModelWithUnMatchableWithJsonAndModel() {
        let data = try! JSONSerialization.data(withJSONObject: testDataModelWithUnMatchableWithJsonAndModelDict , options: [])
        sut = ErrorResponseData<TestDataModel>(data: data)
        switch sut.dataModel() {
        case .success:
            XCTFail("must not be in success in with unmatchable json and model")
        case .failure:
            print("test passed")
            break
        }
    }
    
    func testDataModelWithMatchableWithJsonAndModel() {
        let data = try! JSONSerialization.data(withJSONObject: testDataModelWithMatchableWithJsonAndModelDict, options: [])
        sut = ErrorResponseData<TestDataModel>(data: data)
        switch sut.dataModel() {
        case .success:
            print("test passed")
        case .failure:
            XCTFail("must not fail with matchable json and model")
            break
        }
    }
    
}





fileprivate let testDataModelWithUnMatchableWithJsonAndModelDict: [String: Any] =
[
    "cache-control": "no-cache"
    
]

fileprivate let testDataModelWithMatchableWithJsonAndModelDict: [String: Any] = [
    "data": "data",
    "id": "1212"
]

fileprivate struct TestDataModel: Decodable, Equatable {
    let data: String
    let id: String
}
