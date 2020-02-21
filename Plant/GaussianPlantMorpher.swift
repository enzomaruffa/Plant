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
        
        let stemLengthProportion = R.randomClosed(plant1.stemLengthProportion, plant2.stemLengthProportion)
        let stemColor = plant1.stemColor.gaussianMix(with: plant2.stemColor)
        
        let branchingProbability = R.randomClosed(plant1.branchingProbability, plant2.branchingProbability)
        
        let dAverateStemLayers = R.randomClosed(Double(plant1.averageStemLayers), Double(plant2.averageStemLayers))
        let averateStemLayers = Int(dAverateStemLayers)
        
        let flowerProbability = R.randomClosed(plant1.flowerProbability, plant2.flowerProbability)
        let stemWidth = R.randomClosed(plant1.stemWidth, plant2.stemWidth)
        let stemAngleFactor = R.randomClosed(plant1.stemAngleFactor, plant2.stemAngleFactor)
        
        return Plant(stemLengthProportion: stemLengthProportion, stemColor: stemColor, branchingProbability: branchingProbability, averageStemLayers: averateStemLayers, flowerProbability: flowerProbability, stemWidth: stemWidth, stemAngleFactor: stemAngleFactor)
        
    }
    
    
}
