//
//  LumberjackConsoleLogFormatter.swift
//  Particle
//
//  Created by Artem Misesin on 8/8/18.
//  Copyright © 2018 Artem Misesin. All rights reserved.
//

import CocoaLumberjack

class LumberjackConsoleLogFormatter: NSObject, MetaDataProtocol {
    var shouldLogMetaData: Bool = true
    
    private static let timestampFormat = "dd/MM/yyyy HH:mm:ss.SSSS"
}

// MARK: - LumberjackConsoleLogFormatter: DDLogFormatter

extension LumberjackConsoleLogFormatter: DDLogFormatter {
    func format(message logMessage: DDLogMessage) -> String? {
        let fileUrl = URL(fileURLWithPath: logMessage.file)
        var formattedString = ""
        
        if let logMessage = logMessage as? LoggerMessage {
            formattedString.append("\(logMessage.logLevel.icon) ")
        }
        if shouldLogMetaData {
            formattedString.append("[\(logMessage.timestamp.formattedString(using: LumberjackConsoleLogFormatter.timestampFormat))] ")
        }
        formattedString.append("\(logMessage.message) ")
        
        if shouldLogMetaData {
            formattedString.append("in \(fileUrl.lastPathComponent)")
            
            if let function = logMessage.function {
                formattedString.append(" > \(function)")
            }
            formattedString.append(" at line \(logMessage.line)")
        }
        
        return formattedString
    }
}
