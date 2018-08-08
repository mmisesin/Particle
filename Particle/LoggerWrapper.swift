//
//  LoggerWrapper.swift
//  Particle
//
//  Created by Artem Misesin on 8/8/18.
//  Copyright © 2018 Artem Misesin. All rights reserved.
//

import Foundation

/// Shortcut for `LoggerWrapper.instance`
let logger = LoggerWrapper.instance

typealias CompoundLoggerProtocol = LoggerProtocol & MetaDataProtocol & LogLevelProtocol

class LoggerWrapper {
    
    private var logger: CompoundLoggerProtocol
    
    static let instance = LoggerWrapper(logger: LumberjackLogger(allowedOutputs: [.console, .file]))
    
    init(logger: CompoundLoggerProtocol) {
        self.logger = logger
    }
    
    // MARK: Public
    
    /// Verbose logging
    func verbose(_ message: String, file: String = #file, function: String? = #function, line: UInt = #line) {
        logger.logMessage(message: message, level: .verbose, file: file, function: function, line: line)
    }
    
    /// Debug logging
    func debug(_ message: String, file: String = #file, function: String? = #function, line: UInt = #line) {
        logger.logMessage(message: message, level: .debug, file: file, function: function, line: line)
    }
    
    /// Information logging
    func info(_ message: String, file: String = #file, function: String? = #function, line: UInt = #line) {
        logger.logMessage(message: message, level: .info, file: file, function: function, line: line)
    }
    
    /// Warning logging
    func warning(_ message: String, file: String = #file, function: String? = #function, line: UInt = #line) {
        logger.logMessage(message: message, level: .warning, file: file, function: function, line: line)
    }
    
    /// Error logging
    func error(_ message: String, file: String = #file, function: String? = #function, line: UInt = #line) {
        logger.logMessage(message: message, level: .error, file: file, function: function, line: line)
    }
    
}

// MARK: - HandyLoggerWrapper: MetaInfoLoggerProtocol

extension LoggerWrapper: MetaDataProtocol {
    var shouldLogMetaData: Bool {
        set {
            logger.shouldLogMetaData = newValue
        }
        get {
            return logger.shouldLogMetaData
        }
    }
}

// MARK: - HandyLoggerWrapper: LogLevelHolderProtocol

extension LoggerWrapper: LogLevelProtocol {
    var allowedLogLevel: LogLevel {
        get {
            return logger.allowedLogLevel
        }
        set {
            logger.allowedLogLevel = newValue
        }
    }
}
