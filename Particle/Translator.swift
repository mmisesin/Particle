//
//  Translator.swift
//  Particle
//
//  Created by Artem Misesin on 11/4/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import Foundation

enum TranslatorType {
    case google, yandex
}

class Translator {
    
    private var type: TranslatorType = .yandex
    
    static let shared = Translator()
    
    private let googleAPIKey = "AIzaSyAie4YCtNVZCcD1hKvp3qAG-cp3W9rjTu8"
    private lazy var googleBaseURL = "https://translation.googleapis.com/language/translate/v2?key=\(self.googleAPIKey)"
    private let yandexAPIKey = "dict.1.1.20180408T151828Z.256bc5f4f0a61741.b082d563d53d250c7a3b6615a94d2562a7bd13c7"
    private lazy var yandexBaseURL = "https://dictionary.yandex.net/api/v1/dicservice.json//lookup?key=\(yandexAPIKey)&lang=en-ru&text="
    
    lazy private var apiKey: String = {
        switch type {
        case .google:
            return googleAPIKey
        case .yandex:
            return yandexAPIKey
        }
    }()
    
    lazy private var baseURL: String = {
        switch type {
        case .google:
            return googleBaseURL
        case .yandex:
            return yandexBaseURL
        }
    }()
    
    func translate(_ text: String, callback: @escaping (TranslationResult?) -> Void) {
        var urlString = ""
        if let urlEncodedText = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            switch type {
            case .google:
                urlString = baseURL + "&q=\(urlEncodedText)&source=en&target=ru&format=text"
            case .yandex:
                urlString = baseURL + urlEncodedText
            }
        } else {
            preconditionFailure("There was an error with url encoded text")
        }
        if let url = URL(string: urlString) {
            let request = URLSession.shared.dataTask(with: url) { (data, response, error)  in
                guard error == nil else {
                    callback(nil)
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    
                    guard httpResponse.statusCode == 200 else {
                        
                        if let data = data {
                            print("Response [\(httpResponse.statusCode)] - \(data)")
                        }
                        callback(nil)
                        return
                    }
                    if let data = data {
                        let decoder = JSONDecoder()
                        do {
                            let result = try decoder.decode(TranslationResult.self, from: data)
                            callback(result)
                        } catch {
                            print(error.localizedDescription)
                            callback(nil)
                        }
                    }
                }
            }
            request.resume()
        }
    }
    
}
