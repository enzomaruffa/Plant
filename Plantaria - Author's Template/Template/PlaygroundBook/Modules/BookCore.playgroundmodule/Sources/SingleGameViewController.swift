//
//  SingleGameViewController.swift
//  BookCore
//
//  Created by Enzo Maruffa Moreira on 16/05/20.
//

import UIKit

@objc(BookCore_SingleGameViewController)
public class SingleGameViewController: UIViewController {
    
    // MARK: - Variables
    @IBOutlet weak var plant1Container: UIView!
    private var plant1: Plant?
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var groundView: UIView!
    
    let renderer: PlantRenderer = DefaultRenderer()
    let plantMorpher: PlantMorpher = LinearPlantMorpher()
    
    var plantViews = [UIView]()
    
    public var plant = Plant()
    
    let sound = SFXPlayer.shared
    
    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        plantViews = [plant1Container]
        
        spawnClouds()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.createPlant(self.plant, at: 0)
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
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
            rockImageView.transform = CGAffineTransform(
                translationX: plantView.frame.width * CGFloat.random(in: -0.35...1.35),
                y: rockY - plantView.frame.width * CGFloat.random(in: 0.56...0.9))
        }) { (_) in
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
                rockImageView.alpha = 0
            }) { (_) in
                rockImageView.removeFromSuperview()
            }
        }
    }
    
    private func createPlant(_ plant: Plant = Plant(), at plantIndex: Int) {
        let plantView = plantViews[plantIndex]
        
        let (stemLayers, flowerLayers) = renderer.render(plant: plant, in: plantView.frame)
        animateLayers(stemLayers, flowerLayers)
        
        plantView.layer.addSublayers(stemLayers + flowerLayers)
        
        (0..<Int.random(in: 4...6)).forEach { (_) in
            addRock(intoPlantView: plantView)
        }
        
        switch plantIndex {
        case 0:
            plant1 = plant
        default:
            print("Unknown tag \(plantIndex)")
        }
        
        sound.playThud()
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
        default:
            return nil
        }
    }
    
}
