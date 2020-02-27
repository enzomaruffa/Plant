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
        let layers = renderer.render(plant: morphedPlant, in: morphed.frame)
        
        morphed.layer.addSublayers(layers)
    }
    
    @IBAction func random1Pressed(_ sender: Any) {
        plant1 = Plant()
//
//        plant1 = Plant(stemLengthProportion: 0.8, stemColor: .red, branchingProbability: 0.4, averageStemLayers: 3, flowerProbability: 0.6, stemWidth: 2, stemAngleFactor: 0.1, flowerCoreRadius: 0.5, flowerCoreColor: .blue, flowerCoreStrokeWidth: 1, flowerCoreStrokeColor: .blue, flowerLayersCount: 2, petalRadius: 2, petalsInFirstLayer: 4, petalsInLastLayer: 4, petalsFirstLayerColor: .red, petalsLastLayerColor: .yellow, petalStrokeColor: .green)
        
        random1.layer.sublayers?.forEach({ $0.removeFromSuperlayer() })
        let layers = renderer.render(plant: plant1, in: random1.frame)
        
        random1.layer.addSublayers(layers)
    }
    
    @IBAction func random2Pressed(_ sender: Any) {
        plant2 = Plant()
        
        random2.layer.sublayers?.forEach({ $0.removeFromSuperlayer() })
        let layers = renderer.render(plant: plant2, in: random2.frame)
        
        random2.layer.addSublayers(layers)
    }
}

extension CALayer {
    func addSublayers(_ layers: [CALayer]) {
        layers.forEach({ self.addSublayer($0) })
    }
}

