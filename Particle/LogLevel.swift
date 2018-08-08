//
//  LogLevel.swift
//  Particle
//
//  Created by Artem Misesin on 7/20/18.
//  Copyright © 2018 Artem Misesin. All rights reserved.
//

import Foundation

enum LogLevel: Int {
    
    case off = 0
    case info
    case debug
    case warning
    case error
    case verbose
    
}

// MARK: - LogLevel (Icon)

extension LogLevel {
    var icon: String {
        switch self {
        case .off:
            return ""
        case .error:
            return "‼️"
        case .warning:
            return "⚠️"
        case .info:
            return "ℹ️"
        case .debug:
            return "💬"
        case .verbose:
            return "🔬"
        }
    }
}

// MARK: - LogLevel (Operators)

extension LogLevel {
    static func <= (left: LogLevel, right: LogLevel) -> Bool {
        return left.rawValue <= right.rawValue
    }
}
