//
//  Plant.swift
//  Plant
//
//  Created by Enzo Maruffa Moreira on 21/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import UIKit

class Plant {
    
    static var maximumStemLayers = 5
    
    /// The lenght of the first stem layer. The lower, the bigger.
    @Ranged(minimum: 1, maximum: 3)
    var stemLengthProportion: Double = Double.random(in: 1...3)
    
    /// The color of the stem.
    var stemColor: UIColor
    
    /// The probability of a branch growing from the first layer.
    @Ranged(minimum: 0, maximum: 0.7)
    var branchingProbability: Double = Double.random(in: 0...1)
    
    /// The probability of a branch growing from the first layer.
    @Ranged(minimum: 1, maximum: 6)
    var averageStemLayers: Int = Int.random(in: 1...5)
    
    /// The probability of a flower growing from a branch tip.
    @Ranged(minimum: 0, maximum: 1)
    var flowerProbability: Double = Double.random(in: 0.1...0.95)
    
    /// The stem thickness.
    @Ranged(minimum: 1, maximum: 5)
    var stemWidth: Double = Double.random(in: 1...5)
    
    /// How probable the stem is to have a more aggressive angle.
    @Ranged(minimum: 0.1, maximum: 1)
    var stemAngleFactor: Double = Double.random(in: 0.05...1)
    
    init() {
        stemColor = UIColor(displayP3Red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
    }
    
    convenience init(stemLength: Double,
                     stemColor: UIColor,
                     branchingProbability: Double,
                     averageStemLayers: Int,
                     flowerProbability: Double,
                     stemWidth: Double,
                     stemAngleFactor: Double) {
        
        self.init()
        self.stemLengthProportion = stemLength
        self.stemColor = stemColor
        self.branchingProbability = branchingProbability
        self.averageStemLayers = averageStemLayers
        self.flowerProbability = flowerProbability
        self.stemWidth = stemWidth
        self.stemAngleFactor = stemAngleFactor
    }
    
}
