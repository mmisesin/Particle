//
//  StyledItem+CoreDataProperties.swift
//  
//
//  Created by Artem Misesin on 8/20/18.
//
//

import Foundation
import CoreData


extension StyledItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StyledItem> {
        return NSFetchRequest<StyledItem>(entityName: "StyledItem")
    }

    @NSManaged public var index: Int64
    @NSManaged public var style: String?
    @NSManaged public var paragraph: Paragraph?

}
