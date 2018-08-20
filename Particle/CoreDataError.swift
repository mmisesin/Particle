//
//  CoreDataError.swift
//  Particle
//
//  Created by Artem Misesin on 8/12/18.
//  Copyright © 2018 Artem Misesin. All rights reserved.
//

import Foundation

public enum CoreDataError: Error {
    case saveFailed(Error)
    case deleteFailed(Error)
}
