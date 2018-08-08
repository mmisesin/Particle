//
//  LoggerMessage.swift
//  Particle
//
//  Created by Artem Misesin on 7/20/18.
//  Copyright © 2018 Artem Misesin. All rights reserved.
//

import CocoaLumberjack

class LoggerMessage: DDLogMessage {
    
    var logLevel: LogLevel
    
    init(logLevel: LogLevel, message: String, file: String, function: String?, line: UInt) {
        self.logLevel = logLevel
        super.init(message: message, level: logLevel.ddLogLevel, flag: logLevel.ddLogFlag, context: 0, file: file, function: function, line: line, tag: nil, options: [], timestamp: Date())
    }
    
}

// MARK: - HandyLogLevel (DD)
// Use explicit conversion from HandyLogLevel to DDLogLevel and from HandyLogLevel to DDLogFlag
// to make sure it will work properly even if CocoaLumberjack updates it's enums or something.
private extension LogLevel {
    var ddLogLevel: DDLogLevel {
        switch self {
        case .off:
            return .off
        case .error:
            return .error
        case .warning:
            return .warning
        case .info:
            return .info
        case .debug:
            return .debug
        case .verbose:
            return .verbose
        }
    }
    
    var ddLogFlag: DDLogFlag {
        switch self {
        // Since DDLogFlag doesn't contain .off member I convert HandyLogLevel.off to DDLogFlag.error to make switch exhaustive. It will not affect at logger work in any way.
        case .off, .error:
            return .error
        case .warning:
            return .warning
        case .info:
            return .info
        case .debug:
            return .debug
        case .verbose:
            return .verbose
        }
    }
}
