//
//  GameViewController.swift
//  Plant
//
//  Created by Enzo Maruffa Moreira on 01/03/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    // MARK: - Variables
    @IBOutlet weak var plant1Container: UIView!
    private var plant1: Plant?
    
    @IBOutlet weak var plant2Container: UIView!
    private var plant2: Plant?
    
    @IBOutlet weak var plant3Container: UIView!
    private var plant3: Plant?
    
    @IBOutlet weak var plant4Container: UIView!
    private var plant4: Plant?
    
    @IBOutlet weak var plant5Container: UIView!
    private var plant5: Plant?
    
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var mixButton: UIButton!
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var groundView: UIView!
    
    let renderer: PlantRenderer = DefaultRenderer()
    let plantMorpher: PlantMorpher = LinearPlantMorpher()
    
    var plantViews = [UIView]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        plantViews = [plant1Container, plant2Container, plant3Container, plant4Container, plant5Container]
    }
    
    // MARK: - Outlets
    
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
    
    fileprivate func movePlant(_ sender: UILongPressGestureRecognizer, _ snapshot: UIView) {
        let location = sender.location(in: self.view)
        //            snapshot.center = CGPoint(x:view.center.x + (location.x - view.center.x),
        //                                      y:view.center.y + (location.y - view.center.y))
        snapshot.center = CGPoint(x: location.x, y: location.y - snapshot.frame.height/1.8)
    }
    
    fileprivate func checkPlantAction(_ i: Int, _ originalPlant: Plant) {
        if let plant = getPlantFromTag(i) {
            // mix
            let plantTags = 0..<plantViews.count
            
            guard let emptyTag = plantTags.filter({ getPlantFromTag($0) == nil }).shuffled().first else {
                return
            }
            
            let newPlant = plantMorpher.morph(originalPlant, plant)
            createPlant(newPlant, at: emptyTag)
        } else {
            // copy
            createPlant(originalPlant, at: i)
        }
    }
    
    fileprivate func animateSnapshot(_ plantView: UIView, _ snapshot: UIView) {
        let center = plantView.center
        snapshot.center = center
        snapshot.alpha = 0
        
        backgroundView.addSubview(snapshot)
        
        UIView.animate(withDuration: 0.4, animations: {
            snapshot.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            snapshot.alpha = 0.75
        })
        
        UIView.animate(withDuration: 0.2, delay: 0.4, options: [.repeat, .autoreverse], animations: {
            snapshot.transform = CGAffineTransform(rotationAngle: .pi/16).concatenating(CGAffineTransform(scaleX: 0.5, y: 0.5))
        }, completion: nil)
    }
    
    @IBAction func plantLongPress(_ sender: UILongPressGestureRecognizer) {
        guard let tag = sender.view?.tag else {
            print("Error getting tag from sender")
            return
        }
        
        let plantView = plantViews[tag]
        let state = sender.state
        
        if state == .began {
            guard let snapshot = createSnapshot(from: plantView) else {
                return
            }
            animateSnapshot(plantView, snapshot)
            
        } else if state == .changed {
            guard let snapshot = backgroundView.subviews.last else {
                    return
            }
            movePlant(sender, snapshot)
            
        } else if state == .ended {
            guard let snapshot = backgroundView.subviews.last else {
                    return
            }
            
            for i in 0..<plantViews.count {
                let plantView = plantViews[i]
                let location =  sender.location(in: plantView)
                
                if plantView.point(inside: location, with: nil),
                    let originalPlant = getPlantFromTag(tag) {
                    checkPlantAction(i, originalPlant)
                    break
                }
            }
            
            snapshot.removeFromSuperview()
        }
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
        case 4:
            plant5 = plant
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
        case 4:
            plant5 = nil
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
        case 4:
            return plant5
        default:
            return nil
        }
    }
    
    fileprivate func createSnapshot(from view: UIView) -> UIView? {
//        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
//        defer { UIGraphicsEndImageContext() }
//
//        guard let context = UIGraphicsGetCurrentContext() else {
//            return nil
//        }
//        view.layer.render(in: context)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//
//        let snapshot = UIImageView(image: image)
//        snapshot.layer.masksToBounds = false
        
        let newView = UIView(frame: view.bounds)
        
        for sublayer in (view.layer.sublayers ?? []) {
            if let copiedLayer = NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: sublayer)) as? PlantLayer {
                newView.layer.addSublayer(copiedLayer)
            }
            
//            if let data = try? NSKeyedArchiver.archivedData(withRootObject: PlantLayer.self, requiringSecureCoding: false),
//                let copiedLayer = try? NSKeyedUnarchiver.unarchivedObject(ofClass: PlantLayer.self, from: data) {
//                newView.layer.addSublayer(copiedLayer)
//            }
        }
        
        return newView
    }
}

extension CALayer {
    func addSublayers(_ layers: [CALayer]?) {
        (layers ?? []).forEach({ self.addSublayer($0) })
    }
}
