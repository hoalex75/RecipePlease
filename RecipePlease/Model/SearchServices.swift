//
//  SearchServices.swift
//  RecipePlease
//
//  Created by Alex on 21/04/2019.
//  Copyright © 2019 Alexandre Holet. All rights reserved.
//

import Foundation


public class SearchServices: YummlyIdentifiers {
    var yummlyAccess: YummlyAccess
    private var task: URLSessionDataTask?
    private let session = URLSession(configuration: .default)
    private let stringURLSearchForRecipes = "https://api.yummly.com/v1/api/recipes"
    // recipeId, appID, appKey
    private let stringURLDisplayRecipe = "http://api.yummly.com/v1/api/recipe/%@?_app_id=%@&_app_key=%@"
    var storage: Storage
    
    init(storage: Storage) {
        self.storage = storage
        yummlyAccess = YummlyAccess(appId: "", appKey: "")
        if let yumm = self.getAccess() {
            yummlyAccess = yumm
        }
    }
    
    func getResultsWithIngredients(ingredients: [String], completionHandler: @escaping (Bool, Result?) -> Void) {
        var body = "?_app_id=\(yummlyAccess.appId)&_app_key=\(yummlyAccess.appKey)"
        body += formatingIngredients(ingredients: ingredients)
        let urlOnWhichRequest = URL(string: stringURLSearchForRecipes + body)
        guard let url = urlOnWhichRequest else { return }
        print(url)
        task?.cancel()
        task = session.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    if let error = error {
                        print(error)
                    }
                    completionHandler(false, nil)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completionHandler(false, nil)
                    return
                }
                
                guard let result = try? JSONDecoder().decode(Result.self, from: data) else {
                    completionHandler(false, nil)
                    return
                }
                
                self?.storage.result = result
                self?.storage.ingredientHaveChanged = false
                completionHandler(true, result)
            }
        })
        task?.resume()
    }
    
    func getImage(imageURL: URL,callback: @escaping (Bool, Data?) -> Void) {
        let taskDiff = session.dataTask(with: imageURL, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    print("ici2")
                    return
                }
                
                callback(true, data)
            }
        })
        taskDiff.resume()
    }
    
    func formatingIngredients(ingredients: [String]) -> String {
        var result = ""
        for ingredient in ingredients {
            result.append(encodeIngredients(ingredient))
        }
        return result
    }
    
    private func encodeIngredientsWithSpacesForSearchRequest(_ toEncode: String) -> String {
        let result = toEncode.replacingOccurrences(of: " ", with: "%20")
        return result
    }
    
    private func encodeIngredients(_ toEncode: String) -> String {
        var result = "&allowedIngredient[]="
        var ingredient = toEncode
        if toEncode.hasGotWhitespaces() {
            ingredient = encodeIngredientsWithSpacesForSearchRequest(toEncode)
        }
        result = result + ingredient.lowercased()
        return result
    }
}

extension SearchServices {
    func getRecipe(recipeId: String) {
        let urlRequest = String(format: stringURLDisplayRecipe, recipeId, yummlyAccess.appId, yummlyAccess.appKey)
        let urlOptional = URL(string: urlRequest)
        guard let url = urlOptional else { return }
        task?.cancel()
        task = session.dataTask(with: url, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error != nil else {
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    return
                }
                
                guard let recipe = try? JSONDecoder().decode(Recipe.self, from: data) else {
                    return
                }
                
            }
        })
    }
}
