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
    
    override func setUp() {
        storage = Storage()
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

        let search = SearchServices(storage: storage)
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
        let secondNumber: Int = 120
        
        let result = number.secondsToMinutesString()
        let resultTwo = secondNumber.secondsToMinutesString()
        
        XCTAssertEqual(result, "2 min 20")
        XCTAssertEqual(resultTwo, "2 min")
    }

    // MARK: -GetResults Services
    func testGetResultsServiceWithCorrectDatas() {
        FakeResponseData.requestType = .recipeResults
        let sessionFake = URLSessionFake(data: FakeResponseData.correctData, response: FakeResponseData.responseOK, error: nil)

        let searchService = SearchServices(storage: storage, session: sessionFake)

        let expectation = XCTestExpectation(description: "Wait for queue change")
        searchService.getResultsWithIngredients(ingredients: ["onion", "soup"]) { success, result in
            XCTAssert(success)
            XCTAssertNotNil(result)
            expectation.fulfill()

        }

        wait(for: [expectation], timeout: 0.1)
    }

    func testGetResultsServiceWithIncorrectDatas() {
        FakeResponseData.requestType = .recipeResults
        let sessionFake = URLSessionFake(data: FakeResponseData.incorrectData, response: FakeResponseData.responseOK, error: nil)

        let searchService = SearchServices(storage: storage, session: sessionFake)

        let expectation = XCTestExpectation(description: "Wait for queue change")
        searchService.getResultsWithIngredients(ingredients: ["onion", "soup"]) { success, result in
            XCTAssert(!success)
            XCTAssertNil(result)
            expectation.fulfill()

        }

        wait(for: [expectation], timeout: 0.1)
    }

    func testGetResultsServiceWithResponseKO() {
        FakeResponseData.requestType = .recipeResults
        let sessionFake = URLSessionFake(data: FakeResponseData.correctData, response: FakeResponseData.responseKO, error: nil)

        let searchService = SearchServices(storage: storage, session: sessionFake)

        let expectation = XCTestExpectation(description: "Wait for queue change")
        searchService.getResultsWithIngredients(ingredients: ["onion", "soup"]) { success, result in
            XCTAssert(!success)
            XCTAssertNil(result)
            expectation.fulfill()

        }

        wait(for: [expectation], timeout: 0.1)
    }

    func testGetResultsServiceWithError() {
        FakeResponseData.requestType = .recipeResults
        let sessionFake = URLSessionFake(data: FakeResponseData.correctData, response: FakeResponseData.responseOK, error: FakeResponseData.error)

        let searchService = SearchServices(storage: storage, session: sessionFake)

        let expectation = XCTestExpectation(description: "Wait for queue change")
        searchService.getResultsWithIngredients(ingredients: ["onion", "soup"]) { success, result in
            XCTAssert(!success)
            XCTAssertNil(result)
            expectation.fulfill()

        }

        wait(for: [expectation], timeout: 0.1)
    }

    // MARK: -GetRecipe Services
    func testGetRecipeServiceWithCorrectData() {
        FakeResponseData.requestType = .recipeResults
        let sessionFake = URLSessionFake(data: FakeResponseData.correctData, response: FakeResponseData.responseOK, error: nil)

        let searchService = SearchServices(storage: storage, session: sessionFake)

        let expectation = XCTestExpectation(description: "Wait for queue change")
        searchService.getResultsWithIngredients(ingredients: ["onion", "soup"]) { success, result in
            XCTAssert(success)
            XCTAssertNotNil(result)
            expectation.fulfill()

        }

        wait(for: [expectation], timeout: 0.1)
    }

    func testGetRecipeServiceWithIncorrectData() {
        FakeResponseData.requestType = .recipeResults
        let sessionFake = URLSessionFake(data: FakeResponseData.incorrectData, response: FakeResponseData.responseOK, error: nil)

        let searchService = SearchServices(storage: storage, session: sessionFake)

        let expectation = XCTestExpectation(description: "Wait for queue change")
        searchService.getResultsWithIngredients(ingredients: ["onion", "soup"]) { success, result in
            XCTAssert(!success)
            XCTAssertNil(result)
            expectation.fulfill()

        }

        wait(for: [expectation], timeout: 0.1)
    }

    func testGetRecipeServiceWithResponseKO() {
        FakeResponseData.requestType = .recipeResults
        let sessionFake = URLSessionFake(data: FakeResponseData.correctData, response: FakeResponseData.responseKO, error: nil)

        let searchService = SearchServices(storage: storage, session: sessionFake)

        let expectation = XCTestExpectation(description: "Wait for queue change")
        searchService.getResultsWithIngredients(ingredients: ["onion", "soup"]) { success, result in
            XCTAssert(!success)
            XCTAssertNil(result)
            expectation.fulfill()

        }

        wait(for: [expectation], timeout: 0.1)
    }

    func testGetRecipeServiceWithError() {
        FakeResponseData.requestType = .recipeResults
        let sessionFake = URLSessionFake(data: FakeResponseData.correctData, response: FakeResponseData.responseOK, error: FakeResponseData.error)

        let searchService = SearchServices(storage: storage, session: sessionFake)

        let expectation = XCTestExpectation(description: "Wait for queue change")
        searchService.getResultsWithIngredients(ingredients: ["onion", "soup"]) { success, result in
            XCTAssert(!success)
            XCTAssertNil(result)
            expectation.fulfill()

        }

        wait(for: [expectation], timeout: 0.1)
    }
}
