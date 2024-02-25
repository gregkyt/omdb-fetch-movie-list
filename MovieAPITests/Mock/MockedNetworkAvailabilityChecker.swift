//
//  MockedNetworkAvailabilityChecker.swift
//  MovieAPITests
//
//  Created by Bangkit on 26/02/24.
//

import Foundation
import Mockit
import XCTest
import Promises
@testable import Alamofire
@testable import MovieAPI

final class MockedNetworkAvailabilityChecker: NetworkAvailabilityChecker, Mock {
    typealias InstanceType = MockedNetworkAvailabilityChecker
    let callHandler: CallHandler
    
    func instanceType() -> MockedNetworkAvailabilityChecker {
        return self
    }
    
    init(testCase: XCTestCase) {
        self.callHandler = CallHandlerImpl(withTestCase: testCase)
    }
    
    var reachabilityManager: NetworkReachabilityManager?
    
    func startListening(
        completion: @escaping (NetworkReachabilityManager.NetworkReachabilityStatus) -> ()
    ) {
        callHandler
            .accept(nil,
                    ofFunction: #function,
                    atFile: #file,
                    inLine: #line,
                    withArgs: completion)
    }
}
