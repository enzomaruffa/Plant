//
//  GameViewController.swift
//  Plant
//
//  Created by Enzo Maruffa Moreira on 01/03/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    // MARK: - CurrentTool Declaration
    enum CurrentTool {
        case copy
        case mix
    }
    
    // MARK: - Variables
    @IBOutlet weak var plant1Container: UIView!
    private var plant1: Plant?
    
    @IBOutlet weak var plant2Container: UIView!
    private var plant2: Plant?
    
    @IBOutlet weak var plant3Container: UIView!
    private var plant3: Plant?
    
    @IBOutlet weak var plant4Container: UIView!
    private var plant4: Plant?
    
    @IBOutlet weak var light1: UIView!
    @IBOutlet weak var light2: UIView!
    @IBOutlet weak var light3: UIView!
    @IBOutlet weak var light4: UIView!
    
    var currentTool: CurrentTool?
    
    var toolIndex1: Int?
    var toolIndex2: Int?
    
    let renderer: PlantRenderer = DefaultRenderer()
    let plantMorpher: PlantMorpher = LinearPlantMorpher()
    
    var plantViews = [UIView]()
    var lightViews = [UIView]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        plantViews = [plant1Container, plant2Container, plant3Container, plant4Container]
        lightViews = [light1, light2, light3, light4]
        
        lightViews.forEach({ setLightView(view: $0) })
    }
    
    // MARK: - Lifecycle Helpers
    private func setLightView(view: UIView) {
        view.layer.cornerRadius = view.frame.height/2
        turnLightOff(view: view)
    }
    
    // MARK: - Outlets
    @IBAction func copyPressed(_ sender: Any) {
        resetSelections()
        currentTool = .copy
    }
    
    @IBAction func mixPressed(_ sender: Any) {
        resetSelections()
        currentTool = .mix
    }
    
    fileprivate func resetSelections() {
        lightViews.forEach({ turnLightOff(view: $0)} )
        
        toolIndex1 = nil
        toolIndex2 = nil
        currentTool = .none
    }
    
    @IBAction func plantTapped(_ sender: UITapGestureRecognizer) {
        guard let tag = sender.view?.tag else {
            print("Error getting tag from sender")
            return
        }
        
        switch currentTool {
        case .mix:
            mixTapped(tag: tag)
        case .copy:
            copyTapped(tag: tag)
        case .none:
            print("View tapped with no tool selected")
        }
    }
    
    func mixTapped(tag: Int) {
        if toolIndex1 == nil {
            toolIndex1 = tag
            turnLightOn(view: lightViews[tag])
        } else if toolIndex2 == nil {
            toolIndex2 = tag
            turnLightOn(view: lightViews[tag])
        } else {
            guard let plant1 = getPlantFromTag(toolIndex1!),
                let plant2 = getPlantFromTag(toolIndex2!) else {
                print("Error getting plant from tag \(toolIndex1) or tag \(toolIndex2) ")
                return
            }
            
            let newPlant = plantMorpher.morph(plant1, plant2)
            createPlant(newPlant, at: tag)
            resetSelections()
        }
    }
    
    func copyTapped(tag: Int) {
        if toolIndex1 == nil {
            toolIndex1 = tag
            turnLightOn(view: lightViews[tag])
        } else {
            guard let plant = getPlantFromTag(toolIndex1!) else {
                print("Error getting plant from tag \(toolIndex1)")
                return
            }
            createPlant(plant, at: tag)
            
            resetSelections()
        }
    }

    @IBAction func plantSwipeUp(_ sender: UISwipeGestureRecognizer) {
        guard let tag = sender.view?.tag else {
            print("Error getting tag from sender")
            return
        }
        createPlant(at: tag)
    }
    
    @IBAction func plantSwipeDown(_ sender: UISwipeGestureRecognizer) {
        guard let tag = sender.view?.tag else {
            print("Error getting tag from sender")
            return
        }
        removePlant(at: tag)
    }
    
    // MARK: - Helpers
    private func turnLightOff(view: UIView) {
        view.backgroundColor = .darkGray
    }
    
    private func turnLightOn(view: UIView) {
        view.backgroundColor = .yellow
    }
    
    private func createPlant(_ plant: Plant = Plant(), at plantIndex: Int) {
        let plantView = plantViews[plantIndex]
        
        removePlant(at: plantIndex)
        
        let (stemLayers, flowerLayers) = renderer.render(plant: plant, in: plantView.frame)
        animateLayers(stemLayers, flowerLayers)
        
        plantView.layer.addSublayers(stemLayers + flowerLayers)
        
        switch plantIndex {
        case 0:
            plant1 = plant
        case 1:
            plant2 = plant
        case 2:
            plant3 = plant
        case 3:
            plant4 = plant
        default:
            print("Unknown tag \(plantIndex)")
        }
    }
    
    private func removePlant(at plantIndex: Int) {
        let plantView = plantViews[plantIndex]
        plantView.layer.sublayers?.forEach({ $0.removeFromSuperlayer() })
        
        switch plantIndex {
        case 0:
            plant1 = nil
        case 1:
            plant2 = nil
        case 2:
            plant3 = nil
        case 3:
            plant4 = nil
        default:
            print("Unknown tag \(plantIndex)")
        }
    }
    
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
    
    fileprivate func getPlantFromTag(_ tag: Int) -> Plant? {
        switch tag {
        case 0:
            return plant1
        case 1:
            return plant2
        case 2:
            return plant3
        case 3:
            return plant4
        default:
            return nil
        }
    }
}

extension CALayer {
    func addSublayers(_ layers: [CALayer]) {
        layers.forEach({ self.addSublayer($0) })
    }
}
