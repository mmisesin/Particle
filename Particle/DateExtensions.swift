//
//  DateExtensions.swift
//  Particle
//
//  Created by Artem Misesin on 8/8/18.
//  Copyright © 2018 Artem Misesin. All rights reserved.
//

import Foundation

extension Date {
    static let defaultDateTimeFormat = "dd/MM/yyyy HH:mm"
    
    func formattedString(using format: String = Date.defaultDateTimeFormat) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let formattedString = formatter.string(from: self)
        return formattedString
    }
}
