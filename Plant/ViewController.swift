//
//  ViewController.swift
//  Plant
//
//  Created by Enzo Maruffa Moreira on 21/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var random1: UIView!
    @IBOutlet weak var random2: UIView!
    
    @IBOutlet weak var morphed: UIView!
    
    private var plant1: Plant!
    private var plant2: Plant!
    private var morphedPlant: Plant!
    
    let renderer: PlantRenderer = DefaultRenderer()
    let plantMorpher: PlantMorpher = LinearPlantMorpher()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        random1Pressed(self)
        random2Pressed(self)
    }

    @IBAction func morphPlants(_ sender: Any) {
        morphedPlant = plantMorpher.morph(plant1, plant2)
        
        morphed.layer.sublayers?.forEach({ $0.removeFromSuperlayer() })
        let (stemLayers, flowerLayers) = renderer.render(plant: morphedPlant, in: morphed.frame)
        
        animateLayers(stemLayers, flowerLayers)
        
        morphed.layer.addSublayers(stemLayers + flowerLayers)
    }
    
    @IBAction func random1Pressed(_ sender: Any) {
        plant1 = Plant()
//
//        plant1 = Plant(stemLengthProportion: 0.8, stemColor: .red, branchingProbability: 0.4, averageStemLayers: 3, flowerProbability: 0.6, stemWidth: 2, stemAngleFactor: 0.1, flowerCoreRadius: 0.5, flowerCoreColor: .blue, flowerCoreStrokeWidth: 1, flowerCoreStrokeColor: .blue, flowerLayersCount: 2, petalRadius: 2, petalsInFirstLayer: 4, petalsInLastLayer: 4, petalsFirstLayerColor: .red, petalsLastLayerColor: .yellow, petalStrokeColor: .green)
        
        random1.layer.sublayers?.forEach({ $0.removeFromSuperlayer() })
        let (stemLayers, flowerLayers) = renderer.render(plant: plant1, in: random1.frame)
        
        animateLayers(stemLayers, flowerLayers)
        
        random1.layer.addSublayers(stemLayers + flowerLayers)
    }
    
    @IBAction func random2Pressed(_ sender: Any) {
        plant2 = Plant()
        
        random2.layer.sublayers?.forEach({ $0.removeFromSuperlayer() })
        let (stemLayers, flowerLayers) = renderer.render(plant: plant2, in: random1.frame)
        
        animateLayers(stemLayers, flowerLayers)
        
        random2.layer.addSublayers(stemLayers + flowerLayers)
    }
    
    
    // MARK: - Helpers
    fileprivate func animatePlantLayer(_ layer: PlantLayer, duration: CGFloat) {
        // Stroke animation
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = layer.minStrokeStart
        animation.toValue = layer.maxStrokeEnd
        animation.duration = CFTimeInterval(duration)
        
        animation.autoreverses = false
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        layer.add(animation, forKey: "line")
        
        // Width animation
        let previousWidth = layer.lineWidth
        let widthAnimation = CABasicAnimation(keyPath: "lineWidth")
        widthAnimation.fromValue = 0
        widthAnimation.toValue = previousWidth
        widthAnimation.duration = CFTimeInterval(duration) * 2.5
        
        widthAnimation.autoreverses = false
        widthAnimation.fillMode = .forwards
        widthAnimation.isRemovedOnCompletion = false
        
        layer.add(widthAnimation, forKey: "lineWidthAnimation")
        
        // Color animation
        let colorAnimation = CABasicAnimation(keyPath: "fillColor")
        colorAnimation.toValue = layer.animatableFillColor ?? UIColor.clear.cgColor
        colorAnimation.duration = CFTimeInterval(duration) * 2.5
        
        colorAnimation.autoreverses = false
        colorAnimation.fillMode = .forwards
        colorAnimation.isRemovedOnCompletion = false
        
        layer.add(colorAnimation, forKey: "fillColorAnimation")
    }
    
    fileprivate func animateLayers(_ stemLayers: [PlantLayer], _ flowerLayers: [PlantLayer]) {
        let timePerStemLayer: CGFloat = .pi/15
        
        let totalLayerCount = stemLayers.count
        var currentLayer = 0
        
        Timer.scheduledTimer(withTimeInterval: TimeInterval(timePerStemLayer), repeats: true) { (timer) in
            self.animatePlantLayer(stemLayers[currentLayer], duration: timePerStemLayer)
            currentLayer += 1
            if currentLayer >= totalLayerCount {
                timer.invalidate()
            }
        }
        
        let timePerFlowerLayer: CGFloat = .pi/10
        let totalTime = timePerStemLayer * CGFloat(totalLayerCount)
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(totalTime)) {
            for flowerLayer in flowerLayers {
                self.animatePlantLayer(flowerLayer, duration: timePerFlowerLayer)
            }
        }
    }
}

extension CALayer {
    func addSublayers(_ layers: [CALayer]) {
        layers.forEach({ self.addSublayer($0) })
    }
}

