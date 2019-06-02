//
//  YummlyResponseModels.swift
//  RecipePlease
//
//  Created by Alex on 25/05/2019.
//  Copyright © 2019 Alexandre Holet. All rights reserved.
//

import Foundation

struct Result: Decodable {
    let criteria: Criteria
    let matches: [RecipeResult]
    let attribution: Attribution
}

struct Criteria: Decodable {
    let q: String?
    let allowedIngredient: [String]?
    let excludedIngredient: [String]?
}

struct RecipeResult: Decodable {
    let ingredients: [String]
    let id: String
    let recipeName: String
    let totalTimeInSeconds: Int
    let smallImageUrls: [URL]
    let imageUrlsBySize: [String:URL]
    let rating: Int?
    
    func ingredientsToString() -> String {
        var result = ""
        for ingredient in ingredients {
            result.append(ingredient.capitalized)
            result.append(", ")
        }
        result = result.trimmingCharacters(in: .whitespaces)
        result = String(result.dropLast())
        
        return result
    }
}

struct Attribution: Decodable {
    let url: URL
    let text: String
    let logo: URL
}

struct Recipe: Decodable {
    let id: String
    let name: String
    let images: [RecipeImages]
    let source: RecipeSource
    let prepTime: String?
    let cookTime: String?
    let totalTime: String?
    let rating: Int?
    let ingredientLines: [String]
}

struct RecipeImages: Decodable {
    let hostedSmallUrl: URL?
    let hostedMediumUrl: URL?
    let hostedLargeUrl: URL?
    let imageUrlsBySize: [String : URL]?
}

struct RecipeSource: Decodable {
    let sourceDisplayName: String
    let sourceSiteUrl: URL?
    let sourceRecipeUrl: URL?
}
