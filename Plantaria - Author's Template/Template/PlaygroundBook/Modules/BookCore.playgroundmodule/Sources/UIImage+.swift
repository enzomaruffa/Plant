//
//  UIImage+.swift
//  Plant
//
//  Created by Enzo Maruffa Moreira on 15/05/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import UIKit

extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage? {
        let widthProportion = width / size.width
        
        let canvasSize = CGSize(width: size.width * widthProportion, height: size.height * widthProportion)
        
        let renderer = UIGraphicsImageRenderer(size: canvasSize)
        return renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: canvasSize))
        }
    }
    
    func resized(toHeight height: CGFloat) -> UIImage? {
        let heightProportion = height / size.height
        
        let canvasSize = CGSize(width: size.width * heightProportion, height: size.height * heightProportion)
        
        let renderer = UIGraphicsImageRenderer(size: canvasSize)
        return renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: canvasSize))
        }
    }
}
