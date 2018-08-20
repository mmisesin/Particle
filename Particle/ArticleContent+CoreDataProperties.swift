//
//  ArticleContent+CoreDataProperties.swift
//  
//
//  Created by Artem Misesin on 8/20/18.
//
//

import Foundation
import CoreData


extension ArticleContent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleContent> {
        return NSFetchRequest<ArticleContent>(entityName: "ArticleContent")
    }

    @NSManaged public var article: Article?
    @NSManaged public var paragraphs: NSSet?

}

// MARK: Generated accessors for paragraphs
extension ArticleContent {

    @objc(addParagraphsObject:)
    @NSManaged public func addToParagraphs(_ value: Paragraph)

    @objc(removeParagraphsObject:)
    @NSManaged public func removeFromParagraphs(_ value: Paragraph)

    @objc(addParagraphs:)
    @NSManaged public func addToParagraphs(_ values: NSSet)

    @objc(removeParagraphs:)
    @NSManaged public func removeFromParagraphs(_ values: NSSet)

}
