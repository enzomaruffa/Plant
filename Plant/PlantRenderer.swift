//
//  PlantRenderer.swift
//  Plant
//
//  Created by Enzo Maruffa Moreira on 21/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import UIKit

protocol PlantRenderer {
    
    static var minAbsoluteAngle: CGFloat {get}
    static var maxAbsoluteAngle: CGFloat {get}
    func render(plant: Plant, in frame: CGRect) -> [CALayer]
    
}
