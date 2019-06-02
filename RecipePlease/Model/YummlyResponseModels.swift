//
//  YummlyResponseModels.swift
//  RecipePlease
//
//  Created by Alex on 25/05/2019.
//  Copyright © 2019 Alexandre Holet. All rights reserved.
//

import Foundation
import CoreData

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

class RecipeCD: NSManagedObject {
    static func all() -> [RecipeCD] {
        let request: NSFetchRequest<RecipeCD> = RecipeCD.fetchRequest()
        guard let recipes = try? AppDelegate.viewContext.fetch(request) else { return [] }

        return recipes
    }

    func saveARecipe(recipe: Recipe) {
        let recipeImage = RecipeImagesCD(context: AppDelegate.viewContext)
        recipeImage.smallImageURL = recipe.images[0].hostedSmallUrl?.absoluteString
        recipeImage.mediumImageURL = recipe.images[0].hostedMediumUrl?.absoluteString
        recipeImage.largeImageURL = recipe.images[0].hostedLargeUrl?.absoluteString

        let recipeSource = RecipeSourceCD(context: AppDelegate.viewContext)
        recipeSource.sourceDisplayName = recipe.source.sourceDisplayName
        recipeSource.sourceRecipeUrl = recipe.source.sourceRecipeUrl?.absoluteString
        recipeSource.sourceSiteUrl = recipe.source.sourceSiteUrl?.absoluteString

        id = recipe.id
        name = recipe.name
        prepTime = recipe.prepTime
        cookTime = recipe.cookTime
        totalTime = recipe.totalTime
        toImages = recipeImage
        toSource = recipeSource

        for ingredient in recipe.ingredientLines {
            let ingredientCD = IngredientsCD(context: AppDelegate.viewContext)
            ingredientCD.name = ingredient
            ingredientCD.newRelationship = self
        }

        try? AppDelegate.viewContext.save()
    }

    func convertToRecipe() -> Recipe? {
        if let id = id, let name = name {
            RecipeImages(hostedSmallUrl: <#T##URL?#>, hostedMediumUrl: <#T##URL?#>, hostedLargeUrl: <#T##URL?#>, imageUrlsBySize: <#T##[String : URL]?#>)
            var recipe = Recipe(id: id, name: name, images: <#T##[RecipeImages]#>, source: <#T##RecipeSource#>, prepTime: <#T##String?#>, cookTime: <#T##String?#>, totalTime: <#T##String?#>, rating: <#T##Int?#>, ingredientLines: <#T##[String]#>)
        }


        return nil
    }
}

class IngredientsCD: NSManagedObject {
    
}

class RecipeImagesCD: NSManagedObject {
    func convertToRecipeImages() -> RecipeImages {
        let images = RecipeImages(hostedSmallUrl: URL(string: smallImageURL ?? ""), hostedMediumUrl: URL(string: mediumImageURL ?? ""), hostedLargeUrl: URL(string: largeImageURL ?? ""), imageUrlsBySize: nil)

        return images
    }
}

class RecipeSourceCD: NSManagedObject {

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
