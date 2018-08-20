//
//  Translator.swift
//  Particle
//
//  Created by Artem Misesin on 11/4/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import Foundation

protocol TranslatorProtocol {
    
    var configuration: TranslatorConfiguration { get }
    
    func translate(_ text: String, from sourceLanguage: Language, to targetLanguage: Language, callback: @escaping (Data?, APIError?) -> Void)
    
}

class YandexTranslator: TranslatorProtocol {
    
    var configuration: TranslatorConfiguration = TranslatorConfiguration(type: .yandex)
    
    func translate(_ text: String, from sourceLanguage: Language, to targetLanguage: Language, callback: @escaping (Data?, APIError?) -> Void) {
        guard let urlEncodedText = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            callback(nil, APIError(errorDescription: "There was an error with url encoded text"))
            return
        }
        
        let urlString = configuration.apiBaseURL + urlEncodedText
        guard let url = URL(string: urlString) else {
            callback(nil, APIError(errorDescription: "Could not initialize a url from \(urlString)"))
            return
        }
        let request = URLSession.shared.dataTask(with: url) { (data, response, error)  in
            guard
                error == nil,
                let httpResponse = response as? HTTPURLResponse
                else {
                callback(nil, error?.apiError)
                    return
            }
            switch httpResponse.statusCode {
            case 200...299:
                callback(data, nil)
            default:
                callback(nil, APIError(errorDescription: "Request returned \(httpResponse.statusCode) code"))
            }
        }.resume()
    }
    
}

class Translator {
    
    static let shared = Translator()
    
    private let googleAPIKey = ""
    private lazy var googleBaseURL = "\(self.googleAPIKey)"
    private let yandexAPIKey = ""
    private lazy var yandexBaseURL = "\(yandexAPIKey)&lang=en-ru&text="
}
