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
    
    /// Plant stem layer count
    @Ranged(minimum: 1, maximum: 5)
    var stemLayers: Int = Int.random(in: 1...5)
    
    /// The probability of a flower growing from a branch tip.
    @Ranged(minimum: 0.1, maximum: 1)
    var flowerProbability: Double = Double.random(in: 0.5...0.95)
    
    /// The probability of a flower growing from a branch tip.
    @Ranged(minimum: 0, maximum: 90)
    var flowerCount: Int = Int.random(in: 1...7)
    
    /// The stem thickness.
    @Ranged(minimum: 0, maximum: 1)
    var stemWidth: Double = Double.random(in: 0...1)
    
    /// How probable the stem is to have a more aggressive angle.
    @Ranged(minimum: 0.1, maximum: 1)
    var stemAngleFactor: Double = Double.random(in: 0.05...1)
    
    /// The radius that the flower core should have
    @Ranged(minimum: 0, maximum: 1)
    var flowerCoreRadius: Double = Double.random(in: 0...1)

    /// The color the flower core has
    var flowerCoreColor: UIColor

    /// The radius that the flower core should have
    @Ranged(minimum: 1, maximum: 2)
    var flowerCoreStrokeWidth: Double = Double.random(in: 1...2)

    /// The color the flower core has
    var flowerCoreStrokeColor: UIColor

    /// How many layers the flower has
    @Ranged(minimum: 1, maximum: 7)
    var flowerLayersCount: Int = Int.random(in: 1...7)

    /// The petal size proportional to the current belt (stem) length
    @Ranged(minimum: 0.01, maximum: 0.8)
    var petalRadius: Double = Double.random(in: 0.01...0.8)
    
    /// How many petals in the first layer the flower has
    @Ranged(minimum: 2, maximum: 20)
    var petalsInFirstLayer: Int = Int.random(in: 3...6)

    /// How many layers the flower has
    @Ranged(minimum: 4, maximum: 20)
    var petalsInLastLayer: Int = Int.random(in: 4...8)
    
    /// The color the first petal layer has
    var petalsFirstLayerColor: UIColor
    
    /// The color the flower core has
    var petalsLastLayerColor: UIColor
    
    /// The color the flower core has
    var petalStrokeColor: UIColor
    
//    - Variação de cor (chance de mudar a cor na hora de gerar uma camada)
//    - Cor da borda da pétala

    
//    - Número de pétalas na primera camada
//    - Número de pétalas na última camada
//    - Cor da primeira camada de pétala
//    - Cor da segunda camada de pétala
//    - Variação de cor (chance de mudar a cor na hora de gerar uma camada)
//    - Cor da borda da pétala
//    - Grossura da borda da pétala
//    - Sharpness da primeira camada
//    - Sharpness da segunda camada
    
    init() {
        stemColor = UIColor.randomColor()
        flowerCoreColor = UIColor.randomColor()
        flowerCoreStrokeColor = UIColor.randomColor()
        petalsFirstLayerColor = UIColor.randomColor()
        petalsLastLayerColor = UIColor.randomColor()
        petalStrokeColor = UIColor.randomColor()
    }
    
    convenience init(stemLengthProportion: Double,
                     stemColor: UIColor,
                     averageStemLayers: Int,
                     flowerProbability: Double,
                     flowerCount: Int,
                     stemWidth: Double,
                     stemAngleFactor: Double,
                     flowerCoreRadius: Double,
                     flowerCoreColor: UIColor,
                     flowerCoreStrokeWidth: Double,
                     flowerCoreStrokeColor: UIColor,
                     flowerLayersCount: Int,
                     petalRadius: Double,
                     petalsInFirstLayer: Int,
                     petalsInLastLayer: Int,
                     petalsFirstLayerColor: UIColor,
                     petalsLastLayerColor: UIColor,
                     petalStrokeColor: UIColor
                     ) {
        
        self.init()
        self.stemLengthProportion = stemLengthProportion
        self.stemColor = stemColor
        self.stemLayers = averageStemLayers
        self.flowerProbability = flowerProbability
        self.flowerCount = flowerCount
        self.stemWidth = stemWidth
        self.stemAngleFactor = stemAngleFactor
        self.flowerCoreRadius = flowerCoreRadius
        self.flowerCoreColor = flowerCoreColor
        self.flowerCoreStrokeWidth = flowerCoreStrokeWidth
        self.flowerCoreStrokeColor = flowerCoreStrokeColor
        self.flowerLayersCount = flowerLayersCount
        self.petalRadius = petalRadius
        self.petalsInFirstLayer = petalsInFirstLayer
        self.petalsInLastLayer = petalsInLastLayer
        self.petalsFirstLayerColor = petalsFirstLayerColor
        self.petalsLastLayerColor = petalsLastLayerColor
        self.petalStrokeColor = petalStrokeColor
    }
    
}
