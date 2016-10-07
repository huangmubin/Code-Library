//
//  Function Tools.swift
//  Explorer
//
//  Created by 黄穆斌 on 16/9/15.
//  Copyright © 2016年 MuBinHuang. All rights reserved.
//

import Foundation

// MARK: - Tools

/// Create a random Int number in range.
func randomInRange(range: Range<Int>) -> Int {
    let count = UInt32(range.upperBound - range.lowerBound)
    return  Int(arc4random_uniform(count)) + range.lowerBound
}


// MARK: - Class Extension

extension Array {
    
    func element(where predicate: (Element) throws -> Bool) -> Element? {
        if let index = try? self.index(where: predicate) {
            if let index = index {
                return self[index]
            }
        }
        return nil
    }
    
}
