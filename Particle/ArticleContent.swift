//
//  ArticleContent.swift
//  Particle
//
//  Created by Artem Misesin on 7/20/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import Foundation

enum Tag: String {
    case p = "p"
    case h1 = "h1"
    case h2 = "h2"
    case h3 = "h3"
    case h4 = "h4"
    case blockquote = "blockquote"
    case img = "img"
    case figure = "figure"
    case unknown = "_"
}

struct ArticleContent {
    var id: Double?
    var title: String?
    var contentString: [String] = []
    var tags: [Tag] = []
    
    func getTag(from tagName: String) -> Tag {
        if let tag = Tag(rawValue: tagName) {
            return tag
        } else {
            return Tag.unknown
        }
    }
}

struct ArticleParagraph {
    
    var content: String = ""
    var styleTag: Tag = .unknown
    
}
