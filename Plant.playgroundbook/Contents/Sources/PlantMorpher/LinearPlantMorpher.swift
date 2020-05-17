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
        
        var dAverateStemLayers = Float(plant1.stemLayers + plant2.stemLayers) / Float(2)
        // Adds a small disturbance so plants that are on the half can have variations
        dAverateStemLayers += Float.random(in: -0.02...0.02)
        let averateStemLayers = Int(round(dAverateStemLayers))
        
        let flowerProbability = (plant1.flowerProbability + plant2.flowerProbability) / Double(2)
        let flowerCount = (plant1.flowerCount + plant2.flowerCount) / Int(2)
        
        let stemWidth = (plant1.stemWidth + plant2.stemWidth) / Double(2)
        let stemAngleFactor = (plant1.stemAngleFactor + plant2.stemAngleFactor) / Double(2)
        
        let flowerCoreRadius = (plant1.flowerCoreRadius + plant2.flowerCoreRadius) / Double(2)
        let flowerCoreColor = plant1.flowerCoreColor.mix(with: plant2.flowerCoreColor)
        
        let flowerCoreStrokeWidth = (plant1.flowerCoreStrokeWidth + plant2.flowerCoreStrokeWidth) / Double(2)
        let flowerCoreStrokeColor = plant1.flowerCoreStrokeColor.mix(with: plant2.flowerCoreStrokeColor)
        
        let flowerLayersCount = Int((plant1.flowerLayersCount + plant2.flowerLayersCount) / 2)
        
        let petalRadius = (plant1.petalRadius + plant2.petalRadius) / Double(2)
        
        let petalsInFirstLayer = Int((plant1.petalsInFirstLayer + plant2.petalsInFirstLayer) / 2)
        let petalsInLastLayer = Int((plant1.petalsInLastLayer + plant2.petalsInLastLayer) / 2)
        
        let petalsFirstLayerColor = plant1.petalsFirstLayerColor.mix(with: plant2.petalsFirstLayerColor)
        let petalsLastLayerColor = plant1.petalsLastLayerColor.mix(with: plant2.petalsLastLayerColor)
        let petalStrokeColor = plant1.petalStrokeColor.mix(with: plant2.petalStrokeColor)
        
        let petalWidth = (plant1.petalWidth + plant2.petalWidth)/2.0
        
        return Plant(stemLengthProportion: stemLengthProportion,
                     stemColor: stemColor,
                     averageStemLayers: averateStemLayers,
                     flowerProbability: flowerProbability,
                     flowerCount: flowerCount,
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
                     petalStrokeColor: petalStrokeColor,
                     petalWidth: petalWidth
                    )
        
    }
    
    
}
