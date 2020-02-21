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
    
    
    typealias R = PseurandomGenerator
    
    func render(plant: Plant, in frame: CGRect) -> [CALayer] {
        let rootLayer = CALayer()
        rootLayer.frame = frame
        
        /* Before drawing the plant, we define belts
         These belts have a size of the max number of layers + 1. It works like this so we can have
         a numeric value of the max height each stem layer can have. We add 1 so we have space for the flowers inside.
        */
        let beltHeight = frame.height / CGFloat(Plant.maximumStemLayers + 1)
        
        var stemLayers = [CALayer]()
        var branchTips = [CGPoint]()
        
        let plantStemOrigin = CGPoint(x: frame.width/2, y: frame.height)
        
        var stemsToGenerate: [(origin: CGPoint, iteration: Int)] = [(origin: plantStemOrigin, iteration: 1)]
        
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
            let maximumSquared = Double(Plant.maximumStemLayers * Plant.maximumStemLayers)
            let iterationSquared = Double(currentStem.iteration * currentStem.iteration)
            let branchingIterationFactor = iterationSquared / maximumSquared
            let currentProbability = plant.branchingProbability * branchingIterationFactor
            
            if Double.random(in: 0...1) > currentProbability {
                stemsToGenerate.removeFirst()
            }
            
            // Removing first stem to generate
        }
        
        return [rootLayer] + stemLayers
    }
    
    private func createStem(fromPlant plant: Plant, withOrigin origin: CGPoint, maximumHeight: CGFloat , currentIteration: Int) -> (layer: CALayer, endPoint: CGPoint, final: Bool) {
        
        let stemColor = plant.stemColor
        
        let stemPath = UIBezierPath()
        let stemLayer = CAShapeLayer()
        
        stemPath.move(to: origin)
        
        // DRAWING FIRST STEM
        let newStemLength = maximumHeight / CGFloat(plant.stemLengthProportion)
        
        // ANGLE FINDING
        // Loads of math shit behind this in papers.
        let stemDeviationFactor: CGFloat = CGFloat(9 - (7 * plant.stemAngleFactor))
        
        print(Self.maxAbsoluteAngle, Self.minAbsoluteAngle)
        
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
        stemLayer.lineWidth = 4 * CGFloat(plant.stemWidth) * currentIterationFactor
        stemLayer.strokeColor = stemColor.cgColor
        
        if Int.random(in: -1...1) + currentIteration < min(plant.averageStemLayers, Plant.maximumStemLayers) {
            return (layer: stemLayer, endPoint: newPoint, final: false)
        } else {
            return (layer: stemLayer, endPoint: newPoint, final: true)
        }
        
    }
    
    // Check replicator layer for leafs!
}
