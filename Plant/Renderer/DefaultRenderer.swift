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
            let layers = createFlower(at: branchTip, with: plant)
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
    
    private func createFlower(at origin: CGPoint, with plant: Plant) -> [CAShapeLayer] {
        // Creates flower core
        let corePath = UIBezierPath()
        let coreLayer = CAShapeLayer()
        
        let newRadius = plant.flowerCoreRadius * 7 + Self.flowerCoreRadiusBasis
        corePath.move(to: origin)
        
        corePath.addArc(withCenter: origin, radius: CGFloat(newRadius), startAngle: 0, endAngle: 0.001, clockwise: false)
//        corePath.close()
        
        coreLayer.path = corePath.cgPath
        coreLayer.lineCap = .round
        coreLayer.lineJoin = .round
        coreLayer.fillColor = plant.flowerCoreColor.cgColor
        coreLayer.lineWidth = CGFloat(plant.flowerCoreStrokeWidth)
        coreLayer.strokeColor = plant.flowerCoreStrokeColor.cgColor
        
        coreLayer.strokeStart = 1/7
        
        let petalLayer = CAShapeLayer()
        
        let petalPath1 = UIBezierPath()
        petalPath1.move(to: origin)
                
        petalPath1.addLine(to: origin + CGPoint(x: -newRadius, y: 0))
        petalPath1.addCurve(to: origin + CGPoint(x: 0, y: newRadius * 3), controlPoint1: origin + CGPoint(x: -newRadius, y: newRadius), controlPoint2: origin + CGPoint(x: newRadius, y: newRadius/1.5))
        
        let petalPath2 = UIBezierPath()
        petalPath2.move(to: origin)
                
        petalPath2.addLine(to: origin + CGPoint(x: +newRadius, y: 0))
        petalPath2.addCurve(to: origin + CGPoint(x: 0, y: newRadius * 3), controlPoint1: origin + CGPoint(x: +newRadius * 2, y: 0), controlPoint2: origin + CGPoint(x: -newRadius, y: newRadius * 2))
        
        petalPath1.append(petalPath2)
//        petalPath1.close()
        
        petalLayer.path = petalPath1.cgPath
        petalLayer.lineCap = .round
        petalLayer.lineJoin = .round
        petalLayer.fillColor = UIColor.yellow.cgColor
        petalLayer.lineWidth = 1
        petalLayer.strokeColor = UIColor.red.cgColor
                
        petalLayer.strokeStart = 1/7
                
        return [petalLayer, coreLayer]
    }
    // Check replicator layer for leafs!
}
