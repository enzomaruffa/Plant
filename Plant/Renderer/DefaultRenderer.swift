//
//  DefaultRenderer.swift
//  Plant
//
//  Created by Enzo Maruffa Moreira on 21/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import UIKit

class DefaultRenderer: PlantRenderer {
    
    /// The minimum angle a steam branch can grow. This is relative to the ground position, used so that a future branch can't go downwards. Assumes 0 is top
    static var minAbsoluteAngle: CGFloat = -CGFloat.pi/8 * 5
    
    /// The maximum angle a steam branch can grow. This is relative to the ground position, used so that a future branch can't go downwards. Assumes 0 is top
    static var maxAbsoluteAngle: CGFloat = CGFloat.pi/8 * 5
    
    /// The stem width that will be multiplied by the stemWidth
    static var stemWidthBasis: CGFloat = 2
    
    /// The flower width that will be multiplied by the plantCoreSize
    static var flowerCoreRadiusBasis: Double = 3
    
    typealias R = PseurandomGenerator
    
    func render(plant: Plant, in frame: CGRect) -> [CALayer] {
        let rootLayer = CAShapeLayer()
        rootLayer.frame = frame
        
        /* Before drawing the plant, we define belts
         These belts have a size of the max number of layers + 1. It works like this so we can have
         a numeric value of the max height each stem layer can have. We add 1 so we have space for the flowers inside.
         */
        let beltHeight = frame.height / CGFloat(Plant.maximumStemLayers + 1)
        
        var stemLayers = [CAShapeLayer]()
        var branchTips = [CGPoint]()
        
        let plantStemOrigin = CGPoint(x: frame.width/2, y: frame.height)
        
        var stemsToGenerate: [(origin: CGPoint, iteration: Int)] = [(origin: plantStemOrigin, iteration: 1)]
        
        // Used inside the loop to control if another branch should happen
        
        while !stemsToGenerate.isEmpty {
            let currentStem = stemsToGenerate.first!
            let (stemLayer, newOrigin, final) = createStem(fromPlant: plant, withOrigin: currentStem.origin, maximumHeight: beltHeight, currentIteration: currentStem.iteration)
            
            stemLayers.append(stemLayer)
            
            if final {
                branchTips.append(newOrigin)
            } else if currentStem.iteration < Plant.maximumStemLayers {
                stemsToGenerate.append((origin: newOrigin, iteration: currentStem.iteration + 1))
            }
            
            // See if a branch should happen
            // we use a quadratic factor so top branches branch often
            let maximumSquared = Double((Plant.maximumStemLayers-2) * (Plant.maximumStemLayers-2))
            
            let currentIterationAdjusted = max(1, currentStem.iteration-2)
            
            let iterationSquared = Double(currentIterationAdjusted * currentIterationAdjusted)
            let branchingIterationFactor = iterationSquared / maximumSquared
            let currentProbability = plant.branchingProbability * branchingIterationFactor
            
            if Double.random(in: 0...1) > currentProbability {
                stemsToGenerate.removeFirst()
            }
            
        }
        
        var flowerLayers = [CALayer]()
        
        for branchTip in branchTips {
            let layers = createFlower(at: branchTip, with: plant, andStemHeight: beltHeight)
            flowerLayers += layers
        }
        
        return [rootLayer] + stemLayers + flowerLayers
    }
    
    private func createStem(fromPlant plant: Plant, withOrigin origin: CGPoint, maximumHeight: CGFloat , currentIteration: Int) -> (layer: CAShapeLayer, endPoint: CGPoint, final: Bool) {
        
        let stemColor = plant.stemColor
        
        let stemPath = UIBezierPath()
        let stemLayer = CAShapeLayer()
        
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
        
        // new point is relative to the view's zero. we multiply it by y so it goes upwards
        var newPoint = CGPoint(x: sin(previousAngle + stemAngle) * newStemLength, y: -1 * (cos(previousAngle + stemAngle) * newStemLength))
        
        newPoint = previousPoint + newPoint
        
        stemPath.addLine(to: newPoint)
        
        let currentIterationFactor: CGFloat = 1 - CGFloat(currentIteration) * 0.1
        
        stemLayer.path = stemPath.cgPath
        stemLayer.lineCap = .round
        stemLayer.lineJoin = .round
        stemLayer.lineWidth = (Self.stemWidthBasis * (4 * CGFloat(plant.stemWidth)) * currentIterationFactor)
        stemLayer.strokeColor = stemColor.cgColor
        
        if currentIteration < min(plant.averageStemLayers, Plant.maximumStemLayers) {
            return (layer: stemLayer, endPoint: newPoint, final: false)
        } else {
            return (layer: stemLayer, endPoint: newPoint, final: true)
        }
        
    }
    
    private func createFlower(at origin: CGPoint, with plant: Plant, andStemHeight stemHeight: CGFloat) -> [CAShapeLayer] {
        // Creates flower core
        let corePath = UIBezierPath()
        let coreLayer = CAShapeLayer()
        
        let plantCoreRadius = plant.flowerCoreRadius * 5 + Self.flowerCoreRadiusBasis
        corePath.move(to: origin)
        
        corePath.addArc(withCenter: origin, radius: CGFloat(plantCoreRadius), startAngle: 0, endAngle: 0.001, clockwise: false)
        //        corePath.close()
        
        coreLayer.path = corePath.cgPath
        coreLayer.lineCap = .round
        coreLayer.lineJoin = .round
        coreLayer.fillColor = plant.flowerCoreColor.cgColor
        coreLayer.lineWidth = CGFloat(plant.flowerCoreStrokeWidth)
        coreLayer.strokeColor = plant.flowerCoreStrokeColor.cgColor
        
        coreLayer.strokeStart = 1/7
        
        // Create petals
        
        var petalLayers = [CAShapeLayer]()
        
        for i in 0..<plant.flowerLayersCount {
            let firstLayerProportion = CGFloat(plant.flowerLayersCount - i) / CGFloat(plant.flowerLayersCount)
            let lastLayerProportion = CGFloat(i) / CGFloat(plant.flowerLayersCount)
            
            let currentPetalCount = Int(CGFloat(plant.petalsInFirstLayer) * firstLayerProportion + CGFloat(plant.petalsInLastLayer) * lastLayerProportion)
            
            for j in 0..<currentPetalCount {
                let petalAngleFraction = CGFloat.pi * 2 / CGFloat(currentPetalCount)
                
                //Offsets petal layer to create pattern
                let offset = (CGFloat(i%plant.flowerLayersCount) * petalAngleFraction) / CGFloat(plant.flowerLayersCount)
                
                let angle = petalAngleFraction * CGFloat(j) + offset
                
                let layer = createPetal(withOrigin: origin, angle: angle, plant: plant, coreRadius: CGFloat(plantCoreRadius), stemHeight: stemHeight, currentLayer: i)
                petalLayers.append(layer)
            }
        }
        
        
        return petalLayers.reversed() + [coreLayer]
    }
    
    private func createPetal(withOrigin origin: CGPoint, angle: CGFloat, plant: Plant, coreRadius: CGFloat, stemHeight: CGFloat, currentLayer: Int) -> CAShapeLayer {
        
        let petalLayer = CAShapeLayer()
        
        var angleSin = sin(angle)
        angleSin = angleSin > .pi ? -angleSin : angleSin
        var angleCos = cos(angle)
        angleCos = angleCos > .pi ? -angleCos : angleCos
        
        let newOrigin = origin + CGPoint(x: angleCos * CGFloat(currentLayer) * coreRadius, y: angleSin * CGFloat(currentLayer) * coreRadius)
        
        let petalPath1 = UIBezierPath()
        petalPath1.move(to: origin)
        
        
//        var c1AngleSin = sin(angle - .pi/6)
//        c1AngleSin = c1AngleSin > .pi ? -c1AngleSin : c1AngleSin
//        var c1AngleCos = cos(angle - .pi/6)
//        c1AngleCos = c1AngleCos > .pi ? -c1AngleCos : c1AngleCos
//
//        var c2AngleSin = sin(angle + .pi/6)
//        c2AngleSin = c2AngleSin > .pi ? -c2AngleSin : c2AngleSin
//        var c2AngleCos = cos(angle + .pi/6)
//        c2AngleCos = c2AngleCos > .pi ? -c2AngleCos : c2AngleCos
        
        let petalEnd = newOrigin + CGPoint(x: (stemHeight/4 + stemHeight/3 * CGFloat(plant.petalRadius)) * angleCos, y: (stemHeight/4 + stemHeight/3 * CGFloat(plant.petalRadius)) * angleSin)
//
        let path1Offset = origin + CGPoint(x: -coreRadius * angleSin, y: coreRadius * angleCos)
//        let path1ControlPoint1 = newOrigin + CGPoint(x: -coreRadius + -coreRadius * c1AngleCos, y: -coreRadius + -coreRadius * c1AngleSin)
//        let path1ControlPoint2 = newOrigin + CGPoint(x: -coreRadius * 2 + -coreRadius * c1AngleCos, y: coreRadius * 2 + coreRadius * c1AngleSin)
        
        petalPath1.addLine(to: path1Offset)
        petalPath1.addLine(to: petalEnd)
        
        let petalPath2 = UIBezierPath()
        petalPath2.move(to: origin)
        
        let path2Offset = origin + CGPoint(x: coreRadius * angleSin, y: -coreRadius * angleCos)
//        let path2ControlPoint1 = newOrigin + CGPoint(x: -coreRadius + -coreRadius * c2AngleCos, y: -coreRadius + -coreRadius * c2AngleSin)
//        let path2ControlPoint2 = newOrigin + CGPoint(x: -coreRadius * 2 + -coreRadius * c2AngleCos, y: coreRadius * 2 + coreRadius * c2AngleSin)
        
        petalPath2.addLine(to: path2Offset)
        petalPath2.addLine(to: petalEnd)
        
        petalPath1.append(petalPath2)
        
        petalLayer.path = petalPath1.cgPath
        petalLayer.lineCap = .round
        petalLayer.lineJoin = .round
        
        let proportion = CGFloat(currentLayer) / CGFloat(plant.flowerLayersCount)
        let plantFillColor = plant.petalsFirstLayerColor.mix(with: plant.petalsLastLayerColor, andProportion: proportion)
        
        petalLayer.fillColor = plantFillColor.cgColor
        petalLayer.lineWidth = 0.7
        petalLayer.strokeColor = plant.petalStrokeColor.cgColor
        
        petalLayer.strokeStart = 1/7
        
        return petalLayer
    }
    
    // Check replicator layer for leafs!
}
