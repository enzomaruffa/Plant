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
        
        let flowerLayersCount = R.randomClosed(first: plant1.flowerLayersCount, second:  plant2.flowerLayersCount)
        
        let petalRadius = R.randomClosed(first: plant1.petalRadius, second:  plant2.petalRadius)
        
        let petalsInFirstLayer = R.randomClosed(first: plant1.petalsInFirstLayer, second:  plant2.petalsInFirstLayer)
        let petalsInLastLayer = R.randomClosed(first: plant1.petalsInLastLayer, second:  plant2.petalsInLastLayer)
        
        let petalsFirstLayerColor = plant1.petalsFirstLayerColor.gaussianMix(with: plant2.petalsFirstLayerColor)
        let petalsLastLayerColor = plant1.petalsLastLayerColor.gaussianMix(with: plant2.petalsLastLayerColor)
        let petalStrokeColor = plant1.petalStrokeColor.gaussianMix(with: plant2.petalStrokeColor)
        
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
                     flowerCoreStrokeColor: flowerCoreStrokeColor,
                     flowerLayersCount: flowerLayersCount,
                     petalRadius: petalRadius,
                     petalsInFirstLayer: petalsInFirstLayer,
                     petalsInLastLayer: petalsInLastLayer,
                     petalsFirstLayerColor: petalsFirstLayerColor,
                     petalsLastLayerColor: petalsLastLayerColor,
                     petalStrokeColor: petalStrokeColor
                     )
        
        
    }
    
    
}
