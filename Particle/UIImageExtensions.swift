//
//  UIImageExtensions.swift
//  Particle
//
//  Created by Artem Misesin on 7/18/18.
//  Copyright © 2018 Artem Misesin. All rights reserved.
//

import UIKit

extension UIImage {
    
    func scaleImage(toSize newSize: CGSize) -> UIImage {
        
        let aspectFill = self.size.resizeFill(toSize: newSize)
        
        UIGraphicsBeginImageContextWithOptions(aspectFill, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: aspectFill.width, height: aspectFill.height))
        guard let context = UIGraphicsGetImageFromCurrentImageContext() else {
            preconditionFailure("Graphics context is nil")
        }
        let newImage: UIImage = context
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}
