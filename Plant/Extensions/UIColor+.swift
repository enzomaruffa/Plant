//
//  UIColor+.swift
//  Plant
//
//  Created by Enzo Maruffa Moreira on 21/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import UIKit

extension UIColor {
    
    func gaussianMix(with color: UIColor) -> UIColor {
        
        var red1: CGFloat = 0
        var green1: CGFloat = 0
        var blue1: CGFloat = 0
        var alpha1: CGFloat = 0

        self.getRed(&red1, green: &green1, blue: &blue1, alpha: &alpha1)
        
        var red2: CGFloat = 0
        var green2: CGFloat = 0
        var blue2: CGFloat = 0
        var alpha2: CGFloat = 0

        color.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)
        
        let red = PseurandomGenerator.randomClosed(red1, red2)
        let blue = PseurandomGenerator.randomClosed(blue1, blue2)
        let green = PseurandomGenerator.randomClosed(green1, green2)
        let alpha = PseurandomGenerator.randomClosed(alpha1, alpha2)
        
        return UIColor(displayP3Red: red, green: green, blue: blue, alpha: alpha)
        
    }
    
}
