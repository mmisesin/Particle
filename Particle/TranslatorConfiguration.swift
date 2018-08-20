//
//  TranslatorConfiguration.swift
//  Particle
//
//  Created by Artem Misesin on 8/11/18.
//  Copyright © 2018 Artem Misesin. All rights reserved.
//

import Foundation

enum TranslatorConfigurationType: String {
    case yandex = "Yandex"
    case google = "Google"
}

final class TranslatorConfiguration {
    
    let apiBaseURL: String
    
    let apiKey: String
    
    init(type: TranslatorConfigurationType) {
        let bundle: Bundle = .main
        
        guard
            let configuration = bundle.infoDictionary?["\(type.rawValue) Configuration"] as? [String: Any],
            let apiKey = configuration["apiKey"] as? String,
            let apiBaseURL = configuration["baseURL"] as? String
        else {
            preconditionFailure("Translator configuration is invalid or does not exist")
        }
        
        self.apiBaseURL = apiBaseURL
        self.apiKey = apiKey
    }
    
}
