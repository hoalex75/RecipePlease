//
//  RecipePleaseTests.swift
//  RecipePleaseTests
//
//  Created by Alex on 21/04/2019.
//  Copyright © 2019 Alexandre Holet. All rights reserved.
//

import XCTest
@testable import RecipePlease

class RecipePleaseTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testGivenYummlyInstance_WhenGetAccess_ThenAccessAreCorrect() {
        struct TestYummlyInstance: YummlyIdentifiers {
            var yummlyAccess: YummlyAccess?
            
            init() {
                yummlyAccess = getAccess()
            }
        }
        
        let yummlyIdentifiers = TestYummlyInstance()
        
        XCTAssertNotNil(yummlyIdentifiers.yummlyAccess?.appId)
        XCTAssertNotNil(yummlyIdentifiers.yummlyAccess?.appKey)
    }

}
