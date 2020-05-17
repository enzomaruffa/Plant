//
//  DefaultRenderer.swift
//  Plant
//
//  Created by Enzo Maruffa Moreira on 21/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import UIKit

// MARK: - Default Renderer
class DefaultRenderer: PlantRenderer {
    
    // MARK: - Static Variables
    /// The minimum angle a steam branch can grow. This is relative to the ground position, used so that a future branch can't go downwards. Assumes 0 is top
    static var minAbsoluteAngle: CGFloat = -CGFloat.pi/8 * 5
    
    /// The maximum angle a steam branch can grow. This is relative to the ground position, used so that a future branch can't go downwards. Assumes 0 is top
    static var maxAbsoluteAngle: CGFloat = CGFloat.pi/8 * 5
    
    /// The stem width that will be multiplied by the stemWidth
    static var stemWidthBasis: CGFloat = 2
    
    /// The flower width that will be multiplied by the plantCoreSize
    static var flowerCoreRadiusBasis: Double = 2
    
    typealias R = PseurandomGenerator
    
    // MARK: - PlantRenderer
    func render(plant: Plant, in frame: CGRect) -> (stemLayers: [PlantLayer], flowerLayers: [PlantLayer]) {
        
        let rootLayer = PlantLayer()
        rootLayer.frame = frame
        
        /* Before drawing the plant, we define belts
         These belts have a size of the max number of layers + 1. It works like this so we can have
         a numeric value of the max height each stem layer can have. We add 1 so we have space for the flowers inside.
         */
        let multiplier = CGFloat(1.3)
        let beltHeight = (frame.height / CGFloat(Plant.maximumStemLayers + 1)) * multiplier
        
        var stemLayers = [PlantLayer]()
        var branchTips = [CGPoint]()
        
        let plantStemOrigin = CGPoint(x: frame.width/2, y: frame.height)
        
        var originsInLayerLevel: [Int: [(PlantLayer, CGPoint)]] = [:]
        
        originsInLayerLevel[1] = [(rootLayer, plantStemOrigin)]
        
        // 1. Plant skeleton
        for i in 1..<plant.stemLayers {
            let firstPosition = originsInLayerLevel[i]!.first!
            
            let (stemLayer, newOrigin) = createStem(fromPlant: plant, withOrigin: firstPosition.1, maximumHeight: beltHeight, currentIteration: i)
            
            stemLayer.parentPlant = firstPosition.0
            stemLayer.parentPlant!.increaseaPathToTransformIntoStroke(by: 0.2)
            
            stemLayers.append(stemLayer)
            
            originsInLayerLevel[i+1] = [(stemLayer, newOrigin)]
        }
        
        var flowersToGenerate = plant.flowerCount
        
        // 2. While flowers haven't ended
        while flowersToGenerate > 0 {
            
            // Get a random position
            let sqrdLayer = Int.random(in: 1...plant.stemLayers*plant.stemLayers)
            let selectedLayer = Int(ceil(sqrt(Float(sqrdLayer))))
            
            let randomOrigin = originsInLayerLevel[selectedLayer]!.randomElement()!
            
            // Add a new stem
            let (stemLayer, newOrigin) = createStem(fromPlant: plant, withOrigin: randomOrigin.1, maximumHeight: beltHeight, currentIteration: selectedLayer)
            
            stemLayer.parentPlant = randomOrigin.0
            stemLayer.parentPlant!.increaseaPathToTransformIntoStroke(by: 0.45)
            
            stemLayers.append(stemLayer)
            
            if selectedLayer >= plant.stemLayers || Double.random(in: 0...1) < plant.flowerProbability {
                // Generated a flower
                branchTips.append(newOrigin)
                flowersToGenerate -= 1
            } else {
                // Generated a new origin point
                originsInLayerLevel[selectedLayer]?.append((stemLayer, newOrigin))
            }
        }
        
        var flowerLayers = [PlantLayer]()
        let petalDistanceFactor = CGFloat(plant.petalWidth)

        for branchTip in branchTips {
            let layers = createFlower(at: branchTip, with: plant, andStemHeight: beltHeight, petalDistanceFactor: petalDistanceFactor)
            flowerLayers += layers
        }
        
        for layer in stemLayers+flowerLayers {
            layer.strokeStart = layer.minStrokeStart
            layer.strokeEnd = layer.minStrokeStart
        }
        
        return (stemLayers: [rootLayer] + stemLayers, flowerLayers: flowerLayers)
    }
    
    // MARK: - Create Stem
    private func createStem(fromPlant plant: Plant, withOrigin origin: CGPoint, maximumHeight: CGFloat, currentIteration: Int) -> (layer: PlantLayer, endPoint: CGPoint) {
        
        let stemColor = plant.stemColor
        
        let stemPath = UIBezierPath()
        let stemLayer = PlantLayer()
        
        stemPath.move(to: origin)
        
        // DRAWING FIRST STEM
        let newStemLength = maximumHeight / CGFloat(plant.stemLengthProportion)
        
        // ANGLE FINDING
        // Loads of math shit behind this in papers.
        let stemDeviationFactor: CGFloat = CGFloat(9 - (7 * plant.stemAngleFactor))
        
        // Divide by two to get only one side
        let stemDeviation = ((Self.maxAbsoluteAngle - Self.minAbsoluteAngle) / 2) / stemDeviationFactor
        
        // If angle 0, straight upwards.
        // If positive, left If negative, right.
        let stemAngle = R.randomClosed(0, stemDeviation, minimum: Self.minAbsoluteAngle, maximum: Self.maxAbsoluteAngle)
        
        // We get the previous angle and add it to the current angle, so it's relative
        let previousAngle: CGFloat = 0
        let previousPoint: CGPoint = origin
        
        // new point is relative to the view's zero. we multiply it by -1 so it goes upwards
        var newPoint = CGPoint(x: sin(previousAngle + stemAngle) * newStemLength, y: -1 * (cos(previousAngle + stemAngle) * newStemLength))
        
        newPoint = previousPoint + newPoint
        
        if newPoint.y < 0 {
            newPoint = CGPoint(x: newPoint.x, y: abs(newPoint.y))
        }
        
//        stemPath.addLine(to: newPoint)
        
        let multiplier = CGFloat.random(in: -1...1)
        let controlPoint = getQuadraticControlPoint(for: origin, and: newPoint, withDistance: newStemLength * 0.3 * multiplier)
//        stemPath.addLine(to: newPoint)
        stemPath.addQuadCurve(to: newPoint, controlPoint: controlPoint)
        
        stemLayer.path = stemPath.cgPath
        stemLayer.fillColor = UIColor.clear.cgColor
        stemLayer.lineCap = .round
        stemLayer.lineJoin = .round
        stemLayer.lineWidth = Self.stemWidthBasis + (3 * CGFloat(plant.stemWidth))
        stemLayer.strokeColor = stemColor.cgColor
        
        if currentIteration < min(plant.stemLayers, Plant.maximumStemLayers) {
            return (layer: stemLayer, endPoint: newPoint)
        } else {
            return (layer: stemLayer, endPoint: newPoint)
        }
        
    }
    
    // MARK: - Create Flower
    private func createFlower(at origin: CGPoint, with plant: Plant, andStemHeight stemHeight: CGFloat, petalDistanceFactor: CGFloat) -> [PlantLayer] {
        // Creates flower core
        let corePath = UIBezierPath()
        let coreLayer = PlantLayer()
        
        let plantCoreRadius = plant.flowerCoreRadius * 3 + Self.flowerCoreRadiusBasis
        corePath.move(to: origin)
        
        corePath.addArc(withCenter: origin, radius: CGFloat(plantCoreRadius), startAngle: 0, endAngle: 0.001, clockwise: false)
        //        corePath.close()
        
        coreLayer.path = corePath.cgPath
        coreLayer.lineCap = .round
        coreLayer.lineJoin = .round
        coreLayer.animatableFillColor = plant.flowerCoreColor.cgColor
        coreLayer.fillColor = plant.flowerCoreColor.withAlphaComponent(0).cgColor
        coreLayer.lineWidth = CGFloat(plant.flowerCoreStrokeWidth)
        coreLayer.strokeColor = plant.flowerCoreStrokeColor.cgColor
        
        coreLayer.minStrokeStart = 1/7
        
        // Create petals
        
        var petalLayers = [PlantLayer]()
        
        for i in 0..<plant.flowerLayersCount {
            let firstLayerProportion = CGFloat(plant.flowerLayersCount - i) / CGFloat(plant.flowerLayersCount)
            let lastLayerProportion = CGFloat(i) / CGFloat(plant.flowerLayersCount)
            
            let currentPetalCount = Int(CGFloat(plant.petalsInFirstLayer) * firstLayerProportion + CGFloat(plant.petalsInLastLayer) * lastLayerProportion)
            
            for j in 0..<currentPetalCount {
                let petalAngleFraction = CGFloat.pi * 2 / CGFloat(currentPetalCount)
                
                //Offsets petal layer to create pattern
                let offset = (CGFloat(i%plant.flowerLayersCount) * petalAngleFraction) / CGFloat(plant.flowerLayersCount)
                
                let angle = petalAngleFraction * CGFloat(j) + offset
                
                let layer = createPetal(withOrigin: origin, angle: angle, plant: plant, coreRadius: CGFloat(plantCoreRadius), stemHeight: stemHeight, currentLayer: i, distanceFactor: petalDistanceFactor)
                petalLayers.append(layer)
            }
        }
        
        
        return petalLayers.reversed() + [coreLayer]
    }
    
    // MARK: - Create Petal
    private func createPetal(withOrigin origin: CGPoint, angle: CGFloat, plant: Plant, coreRadius: CGFloat, stemHeight: CGFloat, currentLayer: Int, distanceFactor: CGFloat) -> PlantLayer {
        
        let petalLayer = PlantLayer()
        
        var angleSin = sin(angle)
        angleSin = angleSin > .pi ? -angleSin : angleSin
        var angleCos = cos(angle)
        angleCos = angleCos > .pi ? -angleCos : angleCos
        
        let newOrigin = origin + CGPoint(x: angleCos * CGFloat(currentLayer) * coreRadius, y: angleSin * CGFloat(currentLayer) * coreRadius)
        
        
        let petalEnd = newOrigin + CGPoint(x: (stemHeight/6 + stemHeight/4 * CGFloat(plant.petalRadius)) * angleCos, y: (stemHeight/6 + stemHeight/4 * CGFloat(plant.petalRadius)) * angleSin)
        
        
        // Path 1
        let petalPath1 = UIBezierPath()
        petalPath1.move(to: origin)
//
        let path1Offset = origin + CGPoint(x: -coreRadius * angleSin, y: coreRadius * angleCos)
        
        petalPath1.addLine(to: path1Offset)
        
        let pointsDistance = path1Offset.distanceTo(petalEnd)
        let controlPoint1 = getQuadraticControlPoint(for: path1Offset, and: petalEnd, withDistance: pointsDistance * 0.6 * distanceFactor)
        
        petalPath1.addQuadCurve(to: petalEnd, controlPoint: controlPoint1)
        
        
        // Path 2
        let petalPath2 = UIBezierPath()
        petalPath2.move(to: origin)
        
        let path2Offset = origin + CGPoint(x: coreRadius * angleSin, y: -coreRadius * angleCos)
        
        petalPath2.addLine(to: path2Offset)
        
        let controlPoint2 = getQuadraticControlPoint(for: path2Offset, and: petalEnd, withDistance: pointsDistance * 0.6 * distanceFactor * -1)
        
        //        petalPath2.addLine(to: petalEnd)
        petalPath2.addQuadCurve(to: petalEnd, controlPoint: controlPoint2)
        petalPath1.append(petalPath2)
        
        
        // Path parameters
        petalLayer.path = petalPath1.cgPath
        petalLayer.lineCap = .round
        petalLayer.lineJoin = .round
        
        let proportion = CGFloat(currentLayer) / CGFloat(plant.flowerLayersCount)
        let plantFillColor = plant.petalsFirstLayerColor.mix(with: plant.petalsLastLayerColor, andProportion: proportion)
        
        petalLayer.animatableFillColor = plantFillColor.cgColor
        petalLayer.fillColor = plantFillColor.withAlphaComponent(0).cgColor
        petalLayer.lineWidth = 0.9
        petalLayer.strokeColor = plant.petalStrokeColor.cgColor
        
        return petalLayer
    }
    
    // MARK: - Math Helpers
    
    // Ver foto do Schumacher pra explicação
    func getQuadraticControlPoint(for a: CGPoint, and b: CGPoint, withDistance distance: CGFloat) -> CGPoint {
        
        // Ponto médio
        let h = a - CGPoint(x: (a.x - b.x)/2, y: (a.y - b.y)/2)
        
        // Vetor diretor
        let v = CGVector(dx: -(a.y - b.y), dy: a.x - b.x).normalized()
        
        let controlPoint = h + (v * distance).toCGPoint()
        return controlPoint
    }
    
    // Check replicator layer for leafs!
}
