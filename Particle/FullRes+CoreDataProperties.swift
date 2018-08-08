//
//  FullRes+CoreDataProperties.swift
//  Particle
//
//  Created by Artem Misesin on 7/16/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import Foundation
import CoreData

extension FullRes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FullRes> {
        return NSFetchRequest<FullRes>(entityName: "FullRes")
    }

    @NSManaged public var imageData: NSData?
    @NSManaged public var thumbnail: ParticleReading?

}
