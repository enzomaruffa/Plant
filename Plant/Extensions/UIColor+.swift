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
        
        let red = PseurandomGenerator.randomClosed(first: red1, second: red2)
        let blue = PseurandomGenerator.randomClosed(first: blue1, second:  blue2)
        let green = PseurandomGenerator.randomClosed(first: green1, second:  green2)
        let alpha = PseurandomGenerator.randomClosed(first: alpha1, second:  alpha2)
        
        return UIColor(displayP3Red: red, green: green, blue: blue, alpha: alpha)
        
    }
    
    func mix(with color: UIColor) -> UIColor {
        
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
        
        let red = (red1 + red2) / 2
        let blue = (blue1 + blue2) / 2
        let green = (green1 + green2) / 2
        let alpha = (alpha1 + alpha2) / 2
        
        return UIColor(displayP3Red: red, green: green, blue: blue, alpha: alpha)
        
    }
    
    static func randomColor() -> UIColor {
        return UIColor(displayP3Red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
    }
    
}
