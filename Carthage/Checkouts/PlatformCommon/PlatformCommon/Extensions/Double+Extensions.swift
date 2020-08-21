//
//  Double+Extensions.swift
//  PlatformCommon
//
//  Created by Khalid Asad on 4/18/20.
//  Copyright © 2020 Khalid Asad. All rights reserved.
//

public extension Double {
    
    /// Rounds off the double value to the nearest input value.
    func round(nearest: Double) -> Double {
        let n = 1 / nearest
        let numberToRound = self * n
        return numberToRound.rounded() / n
    }
}
