//
//  PlantLayer.swift
//  Plant
//
//  Created by Enzo Maruffa Moreira on 28/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import UIKit

class PlantLayer: CAShapeLayer {
    
    var pathToTransformInto: CGPath?
    
    func increaseaPathToTransformIntoStroke(by amount: CGFloat) {
        self.lineWidth += amount
    }
    
    func setPathToTransformIntoStroke(to amount: CGFloat) {
        self.lineWidth = amount
    }
}
