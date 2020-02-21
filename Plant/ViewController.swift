//
//  ViewController.swift
//  Plant
//
//  Created by Enzo Maruffa Moreira on 21/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var plantRoot: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let testPlant = Plant(stemLength: 1, stemColor: .red, branchingProbability: 0.3, averageStemLayers: 4, flowerProbability: 2, stemWidth: 3, stemAngleFactor: 0.6)
        
        let renderer: PlantRenderer = DefaultRenderer()
        
        plantRoot.layer.addSublayers(renderer.render(plant: testPlant, in: plantRoot.frame))
    }


}

extension CALayer {
    
    func addSublayers(_ layers: [CALayer]) {
        layers.forEach({ self.addSublayer($0) })
    }
    
}
