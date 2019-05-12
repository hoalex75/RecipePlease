//
//  Storage.swift
//  RecipePlease
//
//  Created by Alex on 01/05/2019.
//  Copyright © 2019 Alexandre Holet. All rights reserved.
//

import Foundation

class Storage {
    var result: Result?
    var ingredients: [String]? {
        didSet {
            ingredientHaveChanged = true
        }
    }
    var ingredientHaveChanged: Bool = true
}
