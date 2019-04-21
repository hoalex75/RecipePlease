//
//  YummlyIdentifiers.swift
//  RecipePlease
//
//  Created by Alex on 21/04/2019.
//  Copyright © 2019 Alexandre Holet. All rights reserved.
//

import Foundation

protocol YummlyIdentifiers {
    var yummlyAccess: YummlyAccess? { get }
    
    func getAccess() -> YummlyAccess?
}

extension YummlyIdentifiers {
    func getAccess() -> YummlyAccess? {
        let bundle = Bundle(for: SearchServices.self)
        let url = bundle.url(forResource: "YummlyIdentifiers", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        guard let access = try? JSONDecoder().decode(YummlyAccess.self, from: data) else {
            print("json access mal ")
            return nil
        }
        return access
    }
}

struct YummlyAccess: Decodable {
    let appId: String
    let appKey: String
}
