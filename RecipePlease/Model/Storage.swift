//
//  Storage.swift
//  RecipePlease
//
//  Created by Alex on 01/05/2019.
//  Copyright © 2019 Alexandre Holet. All rights reserved.
//

import Foundation

struct Storage {
    var result: Result?
    static var shared = Storage()
    
    private init(){}
}
