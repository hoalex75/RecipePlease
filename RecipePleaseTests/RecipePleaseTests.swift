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
    var search: SearchServices = SearchServices()

    override func setUp() {
        search = SearchServices()
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

    func testGivenStringWithSpaces_WhenCheckingIfItHasSpaces_ThenResultIsTrue() {
        let stringWithSpaces = "I got"
        let stringWithoutSpaces = "Igot"
        
        let result = stringWithSpaces.hasGotWhitespaces()
        let secondResult = stringWithoutSpaces.hasGotWhitespaces()
        
        XCTAssert(result)
        XCTAssertFalse(secondResult)
    }
    
    
    func testGivenArrayOfIngredientsNotFormated_WhenFormating_ThenResultIsFormatedForRequest() {
        let ingredientTab = ["Soup", "Onion Soup", "Garlic Cloves", "Cognac"]
        
        let result = search.formatingIngredients(ingredients: ingredientTab)
        
        XCTAssertEqual(result, "&allowedIngredient[]=soup&allowedIngredient[]=onion%20soup&allowedIngredient[]=garlic%20cloves&allowedIngredient[]=cognac")
    }
}
