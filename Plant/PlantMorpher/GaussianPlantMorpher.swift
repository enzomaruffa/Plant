//
//  GaussianPlantMorpher.swift
//  Plant
//
//  Created by Enzo Maruffa Moreira on 21/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import Foundation

class GaussianPlantMorpher: PlantMorpher {
    
    typealias R = PseurandomGenerator
    
    func morph(_ plant1: Plant, _ plant2: Plant) -> Plant {
        
        let stemLengthProportion = R.randomClosed(first: plant1.stemLengthProportion, second: plant2.stemLengthProportion)
        let stemColor = plant1.stemColor.gaussianMix(with: plant2.stemColor)
        
        let branchingProbability = R.randomClosed(first: plant1.branchingProbability, second:  plant2.branchingProbability)
        
        let dAverateStemLayers = R.randomClosed(first: Double(plant1.averageStemLayers), second:  Double(plant2.averageStemLayers))
        let averateStemLayers = Int(round(dAverateStemLayers))
        
        let flowerProbability = R.randomClosed(first: plant1.flowerProbability, second: plant2.flowerProbability)
        let stemWidth = R.randomClosed(first: plant1.stemWidth, second:  plant2.stemWidth)
        let stemAngleFactor = R.randomClosed(first: plant1.stemAngleFactor, second:  plant2.stemAngleFactor)
        
        let flowerCoreRadius = R.randomClosed(first: plant1.flowerCoreRadius, second:  plant2.flowerCoreRadius)
        let flowerCoreColor = plant1.flowerCoreColor.gaussianMix(with: plant2.flowerCoreColor)
        
        let flowerCoreStrokeWidth = R.randomClosed(first: plant1.flowerCoreStrokeWidth, second:  plant2.flowerCoreStrokeWidth)
        let flowerCoreStrokeColor = plant1.flowerCoreStrokeColor.gaussianMix(with: plant2.flowerCoreStrokeColor)
        
        return Plant(stemLengthProportion: stemLengthProportion,
                     stemColor: stemColor,
                     branchingProbability: branchingProbability,
                     averageStemLayers: averateStemLayers,
                     flowerProbability: flowerProbability,
                     stemWidth: stemWidth,
                     stemAngleFactor: stemAngleFactor,
                     flowerCoreRadius: flowerCoreRadius,
                     flowerCoreColor: flowerCoreColor,
                     flowerCoreStrokeWidth: flowerCoreStrokeWidth,
                     flowerCoreStrokeColor: flowerCoreStrokeColor)
        
    }
    
    
}
