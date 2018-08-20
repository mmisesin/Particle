//
//  Paragraph+CoreDataProperties.swift
//  
//
//  Created by Artem Misesin on 8/20/18.
//
//

import Foundation
import CoreData


extension Paragraph {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Paragraph> {
        return NSFetchRequest<Paragraph>(entityName: "Paragraph")
    }

    @NSManaged public var type: String?
    @NSManaged public var articleContent: ArticleContent?
    @NSManaged public var items: NSSet?

}

// MARK: Generated accessors for items
extension Paragraph {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: StyledItem)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: StyledItem)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}
