//
//  Particle.swift
//  Particle
//
//  Created by Artem Misesin on 6/28/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit
import CoreData

final class ParticleHandler {
    
    private var articles = [ParticleReading]()
    private var filteredArticles = [ParticleReading]()
    var filteredRanges = [NSRange]()
    
    static let shared = ParticleHandler()
    
    let context = CoreDataStack.mainQueueContext()
    
    func addArticle(url: String, progress: Double = 0.0, creationDate: Date) {
        if let article = NSEntityDescription.insertNewObject(forEntityName: "ParticleReading", into: context) as? ParticleReading {
            let date: Double = NSDate().timeIntervalSince1970
            article.url = url
            article.id = date
            article.creationDate = creationDate as NSDate
            article.progress = progress
            CoreDataStack.saveContext()
        }
    }
    
    func deleteArticle(with id: Double, completion: @escaping (_ response: Bool?) -> Void) {
        for article in articlesData() where article.id == id {
            context.delete(article)
            CoreDataStack.saveContext()
            completion(true)
        }
    }
    
    func articlesData() -> [ParticleReading] {
        do {
            articles = try context.fetch(ParticleReading.fetchRequest())
        } catch {
            print("Error fetching data from CoreData")
        }
        return articles
    }
    
    func loadedArticlesData() -> [ParticleReading] {
        return articlesData().filter { $0.loaded == true }
    }
    
    func filteredArticlesData(with string: String) -> [ParticleReading] {
        filteredArticles = loadedArticlesData().filter({ (article: ParticleReading) -> Bool in
            guard let title = article.title else {
                return false
            }
            if let range = title.lowercased().range(of: string.lowercased()) {
                self.filteredRanges.append(NSRange(range, in: title))
                return title.lowercased().contains(string.lowercased())
            } else {
                return false
            }
        })
        return filteredArticles
    }
    
    func downloadThumbnail(from html: String, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        guard let thumbString = ArticleParser.parseThumbnail(of: html) else {
            let apiError = APIError(errorDescription: "No image found for a thumbnail")
            completion(nil, apiError)
            return
        }
        if let thumbURL = URL(string: thumbString) {
            getDataFromUrl(url: thumbURL) { (data, _, error)  in
                if let error = error {
                    let apiError = APIError(errorDescription: error.localizedDescription)
                    completion(nil, apiError)
                }
                guard let data = data else {
                    return
                }
                completion(data, nil)
            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
}
