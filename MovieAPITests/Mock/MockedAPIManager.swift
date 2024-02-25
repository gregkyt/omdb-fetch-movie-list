//
//  MockedAPIManager.swift
//  MovieAPITests
//
//  Created by Bangkit on 31/01/24.
//

import Foundation
import Mockit
import XCTest
import Promises
import Alamofire
@testable import MovieAPI

final class MockedAPIManager: APIManager, Mock {
    typealias InstanceType = MockedAPIManager
    let callHandler: CallHandler
    
    func instanceType() -> MockedAPIManager {
        return self
    }
    
    init(testCase: XCTestCase) {
        self.callHandler = CallHandlerImpl(withTestCase: testCase)
    }
    
    func callApi(
        url: String,
        method: HTTPMethod,
        parameters: Parameters?,
        encoding: ParameterEncoding?,
        result: @escaping (Result<[String : Any]?>) -> ()
    ) {
        callHandler
            .accept(nil,
                    ofFunction: #function,
                    atFile: #file,
                    inLine: #line,
                    withArgs: url, method, parameters, encoding, result)
    }
}
