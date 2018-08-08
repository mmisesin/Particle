//
//  LumberjackLogger.swift
//  Particle
//
//  Created by Artem Misesin on 8/8/18.
//  Copyright © 2018 Artem Misesin. All rights reserved.
//

import CocoaLumberjack

class LumberjackLogger: NSObject, LoggerProtocol, LogLevelProtocol {
    // MARK: Properties
    private let logFormatters: [LogOutput: DDLogFormatter] = [
        LogOutput.console: LumberjackConsoleLogFormatter(),
        LogOutput.file: LumberjackFileLogFormatter()
    ]
    
    var allowedLogLevel: LogLevel = .off
    
    // MARK: Init
    required init(allowedOutputs: [LogOutput]) {
        super.init()
        setupLoggers(with: allowedOutputs)
    }
    
    private override init() {
        super.init()
    }
    
    // MARK: Public
    func logMessage(message: String, level: LogLevel, file: String, function: String?, line: UInt) {
        guard level <= allowedLogLevel else { return }
        let logMessage = composeMessage(message: message, level: level, file: file, function: function, line: line)
        DDLog.log(asynchronous: false, message: logMessage)
    }
    
    // MARK: Private
    private func composeMessage(message: String, level: LogLevel, file: String, function: String?, line: UInt) -> LoggerMessage {
        let logMessage = LoggerMessage(logLevel: level, message: message, file: file, function: function, line: line)
        return logMessage
    }
    
    private func setupLoggers(with allowedOutputs: [LogOutput]) {
        if allowedOutputs.contains(.console) {
            setupConsoleLogger()
        }
        if allowedOutputs.contains(.file) {
            setupFileLogger(maxNumberOfLogFiles: 1, diskQuota: 5_242_880) // 5 MB
        }
    }
    
    private func setupConsoleLogger() {
        if let consoleLogger = DDTTYLogger.sharedInstance {
            consoleLogger.logFormatter = logFormatters[.console]
            DDLog.add(consoleLogger)
        }
    }
    
    private func setupFileLogger(maxNumberOfLogFiles: UInt, diskQuota: UInt64) {
        let logFileManager = DDLogFileManagerDefault()
        logFileManager?.maximumNumberOfLogFiles = maxNumberOfLogFiles
        logFileManager?.logFilesDiskQuota = diskQuota
        
        if let fileLogger = DDFileLogger(logFileManager: logFileManager) {
            fileLogger.logFormatter = logFormatters[.file]
            DDLog.add(fileLogger)
        }
    }
}

// MARK: - LumberjackLogger: MetaDataProtocol

extension LumberjackLogger: MetaDataProtocol {
    // Use here console log formatter only 'cause file logger always writes meta to the log.
    var shouldLogMetaData: Bool {
        get {
            guard let formatter = logFormatters[.console] as? LumberjackConsoleLogFormatter else { return false }
            return formatter.shouldLogMetaData
        }
        set {
            guard let formatter = logFormatters[.console] as? LumberjackConsoleLogFormatter else { return }
            formatter.shouldLogMetaData = newValue
        }
    }
}
