//
//  LoggerProtocol.swift
//  Particle
//
//  Created by Artem Misesin on 7/19/18.
//  Copyright © 2018 Artem Misesin. All rights reserved.
//

protocol LoggerProtocol {
    init(allowedOutputs: [LogOutput])
    func logMessage(message: String, level: LogLevel, file: String, function: String?, line: UInt)
}
