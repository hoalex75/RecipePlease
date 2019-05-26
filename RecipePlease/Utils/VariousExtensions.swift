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

extension Int {
    func secondsToMinutesString() -> String {
        let number: Int = self
        let minutes = number/60
        let seconds = number%60
        
        if minutes == 0 {
            return String(format: "%d sec", seconds)
        } else if minutes >= 60 {
            return String(format: minutes%60 == 0 ? "%d hr" : "%d hr %d", minutes/60, minutes%60)
        }
        else {
            return String(format: "%d min", minutes)
        }
    }
}
