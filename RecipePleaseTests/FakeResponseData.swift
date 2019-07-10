//
//  FakeResponseData.swift
//  RecipePleaseTests
//
//  Created by Alex on 10/07/2019.
//  Copyright © 2019 Alexandre Holet. All rights reserved.
//

import Foundation

class FakeResponseData {
    private static var resource: String {
        switch FakeResponseData.requestType! {
        case .recipeResults:
            return "RecipeResults"
        case .recipe:
            return "Recipe"
        }
    }
    static var correctData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: FakeResponseData.resource, withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    enum RequestType {
        case recipe
        case recipeResults
    }
    static let incorrectData = "erreur".data(using: .utf8)!

    static let responseOK = HTTPURLResponse(url: URL(string: "http://www.openclassrooms.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    static let responseKO = HTTPURLResponse(url: URL(string: "http://www.openclassrooms.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)
    static var requestType: RequestType?



    class RequestError: Error {}
    static let error = RequestError()

}
