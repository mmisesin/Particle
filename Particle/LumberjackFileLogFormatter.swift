//
//  LumberjackFileLogFormatter.swift
//  Particle
//
//  Created by Artem Misesin on 8/8/18.
//  Copyright © 2018 Artem Misesin. All rights reserved.
//

import Foundation

import CocoaLumberjack

class LumberjackFileLogFormatter: NSObject {
    
}

// MARK: - LumberjackFileLogFormatter: DDLogFormatter

extension LumberjackFileLogFormatter: DDLogFormatter {
    func format(message logMessage: DDLogMessage) -> String? {
        let fileUrl = URL(fileURLWithPath: logMessage.file)
        var formattedString = "\(logMessage.timestamp.formattedString())\t\(logMessage.level.stringLiteral)\t\(logMessage.message) in \(fileUrl.lastPathComponent)"
        
        if let function = logMessage.function {
            formattedString.append(" > \(function)")
        }
        formattedString.append(" at line \(logMessage.line)")
        
        return formattedString
    }
}

private extension DDLogLevel {
    var stringLiteral: String {
        switch self {
        case .info:
            return "INFO"
        case .debug:
            return "DEBUG"
        case .warning:
            return "WARNING"
        case .error:
            return "ERROR"
        case .verbose:
            return "VERBOSE"
        case .all:
            return "ALL"
        case .off:
            return "OFF"
        }
    }
}
