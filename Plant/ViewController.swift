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
    let plantMorpher: PlantMorpher = GaussianPlantMorpher()
    
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

