//
//  Article+CoreDataProperties.swift
//
//
//  Created by Artem Misesin on 8/20/18.
//
//

import Foundation
import CoreData


extension Article {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }

    @NSManaged public var creationDate: NSDate?
    @NSManaged public var isLoaded: Bool
    @NSManaged public var lastRead: NSDate?
    @NSManaged public var progress: Double
    @NSManaged public var thumbnail: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var content: ArticleContent?

}
