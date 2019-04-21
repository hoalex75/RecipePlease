//
//  SearchServices.swift
//  RecipePlease
//
//  Created by Alex on 21/04/2019.
//  Copyright © 2019 Alexandre Holet. All rights reserved.
//

import Foundation


public class SearchServices: YummlyIdentifiers {
    var yummlyAccess: YummlyAccess?
    private var task: URLSessionDataTask?
    
    init() {
        self.yummlyAccess = getAccess()
    }
    
    func getImage(imageURL: URL,callback: @escaping (Bool, Data?) -> Void) {
        let session = URLSession(configuration: .default)
        
        task?.cancel()
        task = session.dataTask(with: imageURL, completionHandler: { (data, response, error) in
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
        task?.resume()
    }
}

struct Result: Decodable {
    let criteria: Criteria
    let matches: [RecipeResult]
    let attribution: Attribution
}

struct Criteria: Decodable {
    let q: String
    let allowedIngredient: String?
    let excludedIngredient: String?
}

struct RecipeResult: Decodable {
    let ingredients: [String]
    let id: String
    let recipeName: String
    let totalTimeInSeconds: Int
    let smallImageUrls: [URL]
}

struct Attribution: Decodable {
    let url: URL
    let text: String
    let logo: URL
}
