//
//  ParticleReading+CoreDataClass.swift
//  Particle
//
//  Created by Artem Misesin on 7/16/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit
import CoreData

public class ParticleReading: NSManagedObject {

    func saveImage(from data: Data) {
        if let image = UIImage(data: data) {
            let size = CGSize(width: 200, height: 200)
            let thumbnail: UIImage = image.scaleImage(toSize: size)
            if let newData = UIImageJPEGRepresentation(thumbnail, 1) as NSData? {
                self.thumbnail = newData
                CoreDataStack.saveContext()
            }
        }
    }
    
    func parse(html: String) {
        self.title = ArticleParser.parseTitle(of: html)
        self.content = html
        self.loaded = true
        CoreDataStack.saveContext()
    }
    
}
