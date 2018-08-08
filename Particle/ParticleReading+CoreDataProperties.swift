//
//  ParticleReading+CoreDataProperties.swift
//  Particle
//
//  Created by Artem Misesin on 7/16/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import Foundation
import CoreData

extension ParticleReading {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ParticleReading> {
        return NSFetchRequest<ParticleReading>(entityName: "ParticleReading")
    }

    @NSManaged public var content: String?
    @NSManaged public var creationDate: NSDate?
    @NSManaged public var id: Double
    @NSManaged public var lastRead: NSDate?
    @NSManaged public var loaded: Bool
    @NSManaged public var progress: Double
    @NSManaged public var thumbnail: NSData?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var fullRes: FullRes?

}
