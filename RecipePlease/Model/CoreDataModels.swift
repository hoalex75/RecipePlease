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

    static func deleteRecipe(recipe: Recipe,completionHandler: (() -> Void),onError: (() -> Void)) {
        let request: NSFetchRequest<RecipeCD> = RecipeCD.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", recipe.id)

        do {
            let recipes = try AppDelegate.viewContext.fetch(request)
            guard recipes.count > 0 else { return }
            let recipeToDelete = recipes[0]
            AppDelegate.viewContext.delete(recipeToDelete)

            do {
                try AppDelegate.viewContext.save()
                completionHandler()
            } catch {
                onError()
            }

        } catch {
            onError()
        }
    }

    func saveARecipe(recipe: Recipe, completionHandler: (() -> Void)? = nil, onError: (() -> Void)? = nil) {
        let recipeImage = RecipeImagesCD(context: AppDelegate.viewContext)
        recipeImage.initializeRecipeImageWithRecipe(recipe: recipe)
        toImages = recipeImage

        let recipeSource = RecipeSourceCD(context: AppDelegate.viewContext)
        recipeSource.initializeRecipeSourceWithRecipe(recipe: recipe)
        toSource = recipeSource

        initializeWithRecipe(recipe: recipe)

        do {
            try AppDelegate.viewContext.save()
            completionHandler?()
        } catch {
            onError?()
        }
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

    private func initializeWithRecipe(recipe: Recipe) {
        id = recipe.id
        name = recipe.name
        prepTime = recipe.prepTime
        cookTime = recipe.cookTime
        totalTime = recipe.totalTime

        if let ratingRecipe = recipe.rating {
            rating = Int16(ratingRecipe)
        }

        for ingredient in recipe.ingredientLines {
            let ingredientCD = IngredientsCD(context: AppDelegate.viewContext)
            ingredientCD.name = ingredient
            ingredientCD.newRelationship = self
        }
    }
}

class IngredientsCD: NSManagedObject {
}

class RecipeImagesCD: NSManagedObject {
    func convertToRecipeImages() -> RecipeImages {
        let images = RecipeImages(hostedSmallUrl: URL(string: smallImageURL ?? ""), hostedMediumUrl: URL(string: mediumImageURL ?? ""), hostedLargeUrl: URL(string: largeImageURL ?? ""), imageUrlsBySize: nil)

        return images
    }

    func initializeRecipeImageWithRecipe(recipe: Recipe) {
        smallImageURL = recipe.images[0].hostedSmallUrl?.absoluteString
        mediumImageURL = recipe.images[0].hostedMediumUrl?.absoluteString
        largeImageURL = recipe.images[0].hostedLargeUrl?.absoluteString
        if let iconImage = recipe.images[0].imageUrlsBySize {
            imageIcon = iconImage["90"]?.absoluteString
        }
    }
}

class RecipeSourceCD: NSManagedObject {
    func convertToRecipeSource() -> RecipeSource {
        let source = RecipeSource(sourceDisplayName: sourceDisplayName ?? "", sourceSiteUrl: URL(string: sourceSiteUrl ?? ""), sourceRecipeUrl: URL(string: sourceRecipeUrl ?? ""))

        return source
    }

    func initializeRecipeSourceWithRecipe(recipe: Recipe) {
        sourceDisplayName = recipe.source.sourceDisplayName
        sourceRecipeUrl = recipe.source.sourceRecipeUrl?.absoluteString
        sourceSiteUrl = recipe.source.sourceSiteUrl?.absoluteString
    }
}
