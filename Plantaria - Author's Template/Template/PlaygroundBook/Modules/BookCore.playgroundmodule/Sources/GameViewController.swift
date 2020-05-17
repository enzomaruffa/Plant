//
//  GameViewController.swift
//  Plant
//
//  Created by Enzo Maruffa Moreira on 01/03/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import UIKit

@objc(BookCore_GameViewController)
public class GameViewController: UIViewController {
    
    enum Action {
        case mix
        case copy
        case spawn
        case destroy
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
    
    @IBOutlet weak var plant5Container: UIView!
    private var plant5: Plant?
    
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var mixButton: UIButton!
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var groundView: UIView!
    
    let renderer: PlantRenderer = DefaultRenderer()
    let plantMorpher: PlantMorpher = LinearPlantMorpher()
    
    var plantViews = [UIView]()
    
    public let natureOn = false
    
    let sound = SFXPlayer.shared
    let isSongPlaying = false
    
    var rocksRemoved = false
    
    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        plantViews = [plant1Container, plant2Container, plant3Container, plant4Container, plant5Container]
        
        if natureOn {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.nature()
            }
        }
        
        spawnClouds()
    }
    
    func nature() {
        let actions = [Action.spawn, Action.spawn, Action.spawn, Action.spawn, Action.spawn,
                       Action.mix, Action.mix, Action.mix,
                       Action.copy, Action.copy,  Action.copy]
        
        var success = false
        while !success {
            
            let action = actions.randomElement() ?? Action.spawn
            
            switch action {
            case .spawn:
                let randomTag = (0..<plantViews.count).randomElement() ?? 0
                createPlant(at: randomTag)
                success = true
            case .destroy:
                let randomTag = (0..<plantViews.count).randomElement() ?? 0
                removePlant(at: randomTag)
                success = true
            case .copy:
                guard let randomTag = randomPlantTag(),
                    let randomPlant = getPlantFromTag(randomTag) else {
                    continue
                }
                
                var tags = Array((0..<5))
                tags.remove(at: randomTag)
                
                createPlant(randomPlant, at: tags.randomElement()!)
                success = true
            case .mix:
                
                guard let randomTag = randomPlantTag(),
                    let randomPlant = getPlantFromTag(randomTag) else {
                    continue
                }
                
                var tags = Array((0..<5))
                tags.remove(at: randomTag)
                
                guard let randomTag2 = randomPlantTag(usingList: tags),
                    let randomPlant2 = getPlantFromTag(randomTag2) else {
                    continue
                }
                
                tags.removeAll(where: { $0 == randomTag2 })
                
                let newPlant = plantMorpher.morph(randomPlant, randomPlant2)
                createPlant(newPlant, at: tags.randomElement() ?? 0)
                success = true
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 3.5...5.5)) {
            self.nature()
        }
    }
    
    func spawnClouds() {
        let randomCloudImageName = "cloud-"+(Int.random(in: 1...5).description)
        guard let randomCloudImage = UIImage(named: randomCloudImageName) else {
            return
        }
        
        let cloudHeightProportion = CGFloat.random(in: 0.2...0.3)
        let height = cloudHeightProportion * view.frame.height
        
        guard let resizedCloudImage = randomCloudImage.resized(toHeight: height) else {
            return
        }
        
//        let resizedCloudImage = randomCloudImage
        let cloudImageView = UIImageView(image: resizedCloudImage)
        
        view.addSubview(cloudImageView)
        
        let cloudY = view.frame.height * 0.05 + (view.frame.height * CGFloat.random(in: 0...0.3))
        cloudImageView.transform = CGAffineTransform(translationX: -resizedCloudImage.size.width, y: cloudY)
        
        UIView.animate(withDuration: Double.random(in: 25...45), delay: 0, options: [], animations: {
            cloudImageView.transform = CGAffineTransform(translationX: self.view.frame.width + resizedCloudImage.size.width/2, y: cloudY)
        }) { (_) in
            cloudImageView.removeFromSuperview()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 8...30)) {
            self.spawnClouds()
        }
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
        snapshot.center = CGPoint(x: location.x, y: location.y - snapshot.frame.height/1.9)
    }
    
    fileprivate func copyPlant(to i: Int, _ originalPlant: Plant) {
        createPlant(originalPlant, at: i)
    }
    
    fileprivate func mixPlant(to emptyTag: Int, originalPlant: Plant, otherPlant: Plant) {
        let newPlant = plantMorpher.morph(originalPlant, otherPlant)
        createPlant(newPlant, at: emptyTag)
    }
    
    fileprivate func checkPlantAction(_ i: Int, _ originalPlant: Plant) {
        if let plant = getPlantFromTag(i) {
            // mix
            guard let emptyTag = randomNilPlantTag() else {
                return
            }
            
            mixPlant(to: emptyTag, originalPlant: originalPlant, otherPlant: plant)
        } else {
            // copy
            copyPlant(to: i, originalPlant)
        }
    }
    
    fileprivate func animateSnapshot(_ plantView: UIView, _ snapshot: UIView, _ sender: UILongPressGestureRecognizer) {
        snapshot.alpha = 0
        
        backgroundView.addSubview(snapshot)
        
        UIView.animate(withDuration: 0.3, animations: {
            snapshot.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
            snapshot.alpha = 0.8
        })
        
        UIView.animate(withDuration: 0.2, delay: 0.4, options: [.repeat, .autoreverse], animations: {
            snapshot.transform = CGAffineTransform(rotationAngle: .pi/12).concatenating(CGAffineTransform(scaleX: 0.4, y: 0.4))
        }, completion: nil)
        
        movePlant(sender, snapshot)
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
            animateSnapshot(plantView, snapshot, sender)
            
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
    
    fileprivate func addRock(intoPlantView plantView: UIView) {
        let randomRockImageName = "rock-"+(Int.random(in: 1...6).description)
        guard let randomCloudImage = UIImage(named: randomRockImageName) else {
            return
        }
        
        let rockHeightProportion = CGFloat.random(in: 0.02...0.07)
        let height = rockHeightProportion * plantView.frame.height
        
        guard let resizedRockImage = randomCloudImage.resized(toHeight: height) else {
            return
        }
        
        let rockImageView = UIImageView(image: resizedRockImage)
        
        plantView.addSubview(rockImageView)
        
        let rockY = plantView.frame.height
        
        rockImageView.transform = CGAffineTransform(translationX: plantView.frame.width/2, y: rockY)
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
            rockImageView.transform = CGAffineTransform(
                translationX: plantView.frame.width * CGFloat.random(in: -0.35...1.35),
                y: rockY - plantView.frame.width * CGFloat.random(in: 0.56...0.9))
            rockImageView.alpha = 0
        }) { (_) in
            rockImageView.removeFromSuperview()
        }
    }
    
    private func createPlant(_ plant: Plant = Plant(), at plantIndex: Int) {
        let plantView = plantViews[plantIndex]
        
        removePlant(at: plantIndex)
        
        let (stemLayers, flowerLayers) = renderer.render(plant: plant, in: plantView.frame)
        animateLayers(stemLayers, flowerLayers)
        
        plantView.layer.addSublayers(stemLayers + flowerLayers)
        
        (0..<Int.random(in: 4...6)).forEach { (_) in
            addRock(intoPlantView: plantView)
        }
        
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
        
        
        if !isSongPlaying {
            sound.playSong()
        }
        sound.playThud()
    }
    
    private func removePlant(at plantIndex: Int) {
        let plantView = plantViews[plantIndex]
        plantView.layer.sublayers?.forEach({
            guard let layer = $0 as? PlantLayer else {
                return
            }
            
            layer.removeFromSuperlayer()
        })
        
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
        
        rocksRemoved = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.rocksRemoved = false
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
        let timePerStemLayer: CGFloat = .pi/18
        
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
    
    fileprivate func randomNilPlantTag() -> Int? {
        (0..<5).filter({ getPlantFromTag($0) == nil }).shuffled().first
    }
    
    fileprivate func randomPlantTag(usingList tags: [Int]? = nil) -> Int? {
        guard let tags = tags else {
            return (0..<5).filter({ getPlantFromTag($0) != nil }).shuffled().first
        }
        return tags.filter({ getPlantFromTag($0) != nil }).shuffled().first
    }
    
    fileprivate func createSnapshot(from view: UIView) -> UIView? {
        let newView = UIView(frame: view.bounds)
        
        for sublayer in (view.layer.sublayers ?? []) {
            if let copiedLayer = NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: sublayer)) as? PlantLayer {
                newView.layer.addSublayer(copiedLayer)
            }
        }
        
        return newView
    }
}

extension CALayer {
    func addSublayers(_ layers: [CALayer]?) {
        (layers ?? []).forEach({ self.addSublayer($0) })
    }
}
