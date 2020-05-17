//
//  RangedWrapper.swift
//  Plant
//
//  Created by Enzo Maruffa Moreira on 21/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import Foundation

@propertyWrapper
struct Ranged<T: Comparable> {
    private var minimum: T
    private var maximum: T
    private var value: T
    var wrappedValue: T {
        get { value }
        set {
            if newValue > maximum {
                value = maximum
            } else if newValue < minimum {
                value = minimum
            } else {
                value = newValue
            }
        }
    }
    init(wrappedValue: T, minimum: T, maximum: T) {
        self.minimum = minimum
        self.maximum = maximum
        
        self.value = wrappedValue
        self.wrappedValue = wrappedValue
    }
}
