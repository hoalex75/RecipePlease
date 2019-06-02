//
//  CoreDataModels.swift
//  RecipePlease
//
//  Created by Alex on 02/06/2019.
//  Copyright © 2019 Alexandre Holet. All rights reserved.
//

import Foundation
import CoreData

class RecipeCD: NSManagedObject {
    static func all() -> [RecipeCD] {
        let request: NSFetchRequest<RecipeCD> = RecipeCD.fetchRequest()
        guard let recipes = try? AppDelegate.viewContext.fetch(request) else { return [] }

        return recipes
    }

    static func isPresentInDataBase(recipe: Recipe) -> Bool{
        let request: NSFetchRequest<RecipeCD> = RecipeCD.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", recipe.id)
        guard let recipe = try? AppDelegate.viewContext.fetch(request) else { return false }

        if recipe == [] {
            return false
        } else {
            return true
        }
    }

    static func deleteRecipe(recipe: Recipe, onError: (() -> Void)) {
        let request: NSFetchRequest<RecipeCD> = RecipeCD.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", recipe.id)

        do {
            let recipes = try AppDelegate.viewContext.fetch(request)
            guard recipes.count > 0 else { return }
            let recipeToDelete = recipes[0]
            AppDelegate.viewContext.delete(recipeToDelete)

            do {
                try AppDelegate.viewContext.save()
                print("delete done")
            } catch {
                onError()
            }

        } catch {
            onError()
        }
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
        if let ratingRecipe = recipe.rating {
            rating = Int16(ratingRecipe)
        }

        for ingredient in recipe.ingredientLines {
            let ingredientCD = IngredientsCD(context: AppDelegate.viewContext)
            ingredientCD.name = ingredient
            ingredientCD.newRelationship = self
        }

        try? AppDelegate.viewContext.save()
    }

    func convertToRecipe() -> Recipe? {
        if let id = id, let name = name, let toImages = toImages, let toSource = toSource {
            let images = toImages.convertToRecipeImages()
            let source = toSource.convertToRecipeSource()

            let recipe = Recipe(id: id, name: name, images: [images], source: source, prepTime: prepTime, cookTime: cookTime, totalTime: totalTime, rating: Int(rating), ingredientLines: ingredientsLines())

            return recipe
        }


        return nil
    }

    private func ingredientsLines() -> [String] {
        var tab: [String] = []
        guard let toIngredients = toIngredients else { return [] }
        for element in toIngredients {
            if let ingredient = element as? IngredientsCD, let name = ingredient.name {
                tab.append(name)
            }
        }

        return tab
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
    func convertToRecipeSource() -> RecipeSource {
        let source = RecipeSource(sourceDisplayName: sourceDisplayName ?? "", sourceSiteUrl: URL(string: sourceSiteUrl ?? ""), sourceRecipeUrl: URL(string: sourceRecipeUrl ?? ""))

        return source
    }
}
