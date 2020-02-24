//
//  LinearPlantMorpher.swift
//  Plant
//
//  Created by Enzo Maruffa Moreira on 24/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import Foundation

class LinearPlantMorpher: PlantMorpher {
    
    typealias R = PseurandomGenerator
    
    func morph(_ plant1: Plant, _ plant2: Plant) -> Plant {
        
        let stemLengthProportion = (plant1.stemLengthProportion + plant2.stemLengthProportion) / Double(2)
        let stemColor = plant1.stemColor.mix(with: plant2.stemColor)
        
        let branchingProbability = (plant1.branchingProbability + plant2.branchingProbability) / Double(2)
        
        let dAverateStemLayers = Float(plant1.averageStemLayers + plant2.averageStemLayers) / Float(2)
        let averateStemLayers = Int(round(dAverateStemLayers))
        
        let flowerProbability = (plant1.flowerProbability + plant2.flowerProbability) / Double(2)
        let stemWidth = (plant1.stemWidth + plant2.stemWidth) / Double(2)
        let stemAngleFactor = (plant1.stemAngleFactor + plant2.stemAngleFactor) / Double(2)
        
        let flowerCoreRadius = (plant1.flowerCoreRadius + plant2.flowerCoreRadius) / Double(2)
        let flowerCoreColor = plant1.flowerCoreColor.mix(with: plant2.flowerCoreColor)
        
        let flowerCoreStrokeWidth = (plant1.flowerCoreStrokeWidth + plant2.flowerCoreStrokeWidth) / Double(2)
        let flowerCoreStrokeColor = plant1.flowerCoreStrokeColor.mix(with: plant2.flowerCoreStrokeColor)
        
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
