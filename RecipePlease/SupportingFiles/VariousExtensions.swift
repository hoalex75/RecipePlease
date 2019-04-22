//
//  VariousExtensions.swift
//  RecipePlease
//
//  Created by Alex on 22/04/2019.
//  Copyright © 2019 Alexandre Holet. All rights reserved.
//

import Foundation

extension String {
    func hasGotWhitespaces() -> Bool {
        let countRawString = self.count
        let countWithTrimming = self.replacingOccurrences(of: " ", with: "").count
        
        return countRawString > countWithTrimming
    }
}
