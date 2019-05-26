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
    var storage = Storage()
    var search: SearchServices = SearchServices(storage: Storage())
    
    override func setUp() {
        search = SearchServices(storage: storage)
    }

    func testGivenYummlyInstance_WhenGetAccess_ThenAccessAreCorrect() {
        struct TestYummlyInstance: YummlyIdentifiers {
            var yummlyAccess: YummlyAccess
            
            init() {
                yummlyAccess = YummlyAccess(appId: "", appKey: "")
                if let yumm = getAccess() {
                    self.yummlyAccess = yumm
                }
            }
        }
        
        let yummlyIdentifiers = TestYummlyInstance()
        
        XCTAssertNotNil(yummlyIdentifiers.yummlyAccess.appId)
        XCTAssertNotNil(yummlyIdentifiers.yummlyAccess.appKey)
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
    
    func testGivenTabOfIngredients_WhenIngredientsToString_ThenHaveStringOfIngredients() {
        let result = RecipeResult(ingredients: ["butter","gArlic","orange"], id: "12", recipeName: "Soup", totalTimeInSeconds: 123, smallImageUrls: [URL(fileURLWithPath: "")], imageUrlsBySize: ["re" : URL(fileURLWithPath: "")], rating: 1)
        
        let ingredientsString = result.ingredientsToString()
        
        XCTAssertEqual(ingredientsString, "Butter, Garlic, Orange")
    }
    
    func testGivenInt_WhenConvertStringSeconds_ThenConversionIsCorrectlyDone() {
        let number: Int = 140
        
        let result = number.secondsToMinutesString()
        
        XCTAssertEqual(result, "2 min 20")
    }
}
