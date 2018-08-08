//
//  UITextInputExtensions.swift
//  Particle
//
//  Created by Artem Misesin on 7/18/18.
//  Copyright © 2018 Artem Misesin. All rights reserved.
//

import UIKit

extension UITextInput {
    
    var selectedRange: NSRange? {
        guard let range = self.selectedTextRange else { return nil }
        let location = offset(from: beginningOfDocument, to: range.start)
        let length = offset(from: range.start, to: range.end)
        return NSRange(location: location, length: length)
    }
    
}
