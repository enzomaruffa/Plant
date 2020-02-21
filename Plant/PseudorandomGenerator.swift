//
//  PseudorandomGenerator.swift
//  Plant
//
//  Created by Enzo Maruffa Moreira on 21/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import Foundation
import GameplayKit
import CoreGraphics

class PseurandomGenerator {
    
    static func randomClosed(_ minimum: CGFloat, _ maximum: CGFloat) -> CGFloat {
        let random = GKRandomSource()
        
        let average = (minimum + maximum) / 2
        let deviation = (maximum - average) / 3
        
        let generator = GaussianDistribution(randomSource: random, mean: Float(average), deviation: Float(deviation))
        
        var value = generator.nextCGFloat()
        
        value = min(value, maximum)
        value = max(value, minimum)
        
        return CGFloat(value)
    }
    
    static func randomClosed(_ mean: CGFloat, _ sigma: CGFloat, minimum: CGFloat, maximum: CGFloat) -> CGFloat {
        let random = GKRandomSource()
        
        let generator = GaussianDistribution(randomSource: random, mean: Float(mean), deviation: Float(sigma))
        
        var value = generator.nextCGFloat()
        
        value = min(value, maximum)
        value = max(value, minimum)
        
        return CGFloat(value)
    }
    
    static func random(_ mean: CGFloat, _ sigma: CGFloat) -> CGFloat {
        let random = GKRandomSource()
        
        let generator = GaussianDistribution(randomSource: random, mean: Float(mean), deviation: Float(sigma))
        let value = generator.nextCGFloat()
        
        return CGFloat(value)
    }
}

class GaussianDistribution {
    private let randomSource: GKRandomSource
    let mean: Float
    let deviation: Float

    init(randomSource: GKRandomSource, mean: Float, deviation: Float) {
        self.randomSource = randomSource
        self.mean = mean
        self.deviation = abs(deviation)
    }
    
    init(randomSource: GKRandomSource, minimum: Float, maximum: Float) {
        self.randomSource = randomSource
        self.mean = (maximum - minimum) / 2
        self.deviation = (self.mean - minimum) / 3
    }

    func nextCGFloat() -> CGFloat {
        guard deviation > 0 else { return CGFloat(mean) }

        let x1 = randomSource.nextUniform()
        let x2 = randomSource.nextUniform()
        let z1 = sqrt(-2 * log(x1)) * cos(2 * Float.pi * x2)

        // Convert z1 from the Standard Normal Distribution to our Normal Distribution
        return CGFloat(z1 * deviation + mean)
    }
}
