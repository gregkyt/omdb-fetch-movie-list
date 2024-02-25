//
//  MockedUserDefaults.swift
//  MovieAPITests
//
//  Created by Bangkit on 26/02/24.
//

import Foundation
import XCTest
import Mockit

public final class MockedUserDefaults: UserDefaults, Mock {
    public typealias InstanceType = MockedUserDefaults
    
    public func instanceType() -> MockedUserDefaults {
        return self
    }
    
    public var callHandler: CallHandler
    
    public init(testCase: XCTestCase) {
        callHandler = CallHandlerImpl(withTestCase: testCase)
        super.init(suiteName: nil)!
    }
    
    public override func object(forKey defaultName: String) -> Any? {
        return callHandler.accept(
            nil,
            ofFunction: #function,
            atFile: #file,
            inLine: #line,
            withArgs: defaultName
        )
    }
    
    public override func value(forKey key: String) -> Any? {
        return callHandler.accept(
            nil,
            ofFunction: #function,
            atFile: #file,
            inLine: #line,
            withArgs: key
        )
    }
    
    public override func set(_ value: (Any)?, forKey key: String) {
        callHandler.accept(
            nil,
            ofFunction: #function,
            atFile: #file,
            inLine: #line,
            withArgs: value, key
        )
    }
}
