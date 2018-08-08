//
//  ArticleParses.swift
//  Particle
//
//  Created by Artem Misesin on 6/29/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit
import SwiftSoup

final class ArticleParser {
    
    class func parseText(of object: ParticleReading) -> ArticleContent? {
        guard let content = object.content else {
            return nil
        }
        var fetchedArticle = ArticleContent()
        fetchedArticle.id = object.id
        var document: Document
        do {
            document = try SwiftSoup.parse(content)
        } catch {
            preconditionFailure(error.localizedDescription)
        }
        
        do {
            let elements = try document.select("p")
            for element in elements {
                do {
                    fetchedArticle.contentString.append(try element.text())
                    fetchedArticle.tags.append(fetchedArticle.getTag(from: element.tagName()))
                } catch {
                    preconditionFailure(error.localizedDescription)
                }
            }
        } catch {
            preconditionFailure(error.localizedDescription)
        }
//        if let doc = HTML(html: content, encoding: .utf8) {
//            for data in doc.css("p, h2, h3, h4, blockquote") {
//                if let dataString = data.text {
//                    fetchedArticle.contentString.append(dataString)
//                } else {
//                    fetchedArticle.contentString.append("PARSING ERROR")
//                }
//                let tag = fetchedArticle.getTag(from: data.tagName!)
//                fetchedArticle.tags.append(tag)
//            }
//        }
        return fetchedArticle
    }
    
    class func parse(data: String, for tag: String) -> [String?] {
        var parsedData: [String?] = []
        guard let document = try? SwiftSoup.parse(data) else {
            preconditionFailure("Invalid html string")
        }
        guard let elements = try? document.select(tag) else {
            preconditionFailure("Invalid tag string")
        }
        for tagData in elements {
            if let dataString = try? tagData.text() {
                parsedData.append(dataString)
            } else {
                parsedData.append(nil)
            }
        }
        return parsedData
    }
    
    class func parseTitle(of html: String) -> String? {
        for title in parse(data: html, for: "title") {
            if let parsedTitle = title, parsedTitle != "" {
                return parsedTitle
            }
        }
        for title in parse(data: html, for: "h1") {
            if let parsedTitle = title, parsedTitle != "" {
                return parsedTitle
            }
        }
        return nil
    }
    
    class func parseThumbnail(of html: String) -> String? {
        var parsedData: [String] = []
        if let document = try? SwiftSoup.parse(html) {
            if let elements = try? document.select("img") {
                for (index, data) in elements.enumerated() {
                    if parsedData.count >= 2 {
                        break
                    }
                    if index != 0 {
                        if let imageURL = try? data.attr("src") {
                            parsedData.append(imageURL)
                        }
                    }
                }
            }
        }
        if parsedData.isEmpty {
            return nil
        }
        return parsedData[0]
    }
}
