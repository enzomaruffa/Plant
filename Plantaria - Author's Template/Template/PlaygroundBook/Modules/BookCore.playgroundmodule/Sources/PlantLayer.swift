//
//  PlantLayer.swift
//  Plant
//
//  Created by Enzo Maruffa Moreira on 28/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import UIKit

class PlantLayer: CAShapeLayer {
    
    var parentPlant: PlantLayer?
    var minStrokeStart: CGFloat = 0
    var maxStrokeEnd: CGFloat = 1
    var animatableFillColor: CGColor?
    
    func increaseaPathToTransformIntoStroke(by amount: CGFloat, recursive: Bool = true) {
        self.lineWidth += amount
        
        if recursive {
            if let parentLayer = parentPlant {
                parentLayer.increaseaPathToTransformIntoStroke(by: amount, recursive: recursive)
            }
        }
    }
    
    func setPathToTransformIntoStroke(to amount: CGFloat, recursive: Bool = true) {
        self.lineWidth = amount
        
        if recursive {
            if let parentLayer = parentPlant {
                parentLayer.setPathToTransformIntoStroke(to: amount, recursive: recursive)
            }
        }
    }
}
