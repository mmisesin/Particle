//
//  TranslatorWrapper.swift
//  Particle
//
//  Created by Artem Misesin on 8/11/18.
//  Copyright © 2018 Artem Misesin. All rights reserved.
//

import Foundation

class TranslatorWrapper {
    
    private let translator: TranslatorProtocol
    
    init(translator: TranslatorProtocol) {
        self.translator = translator
    }
    
    func translate(_ text: String, from sourceLanguage: Language = .english, to targetLanguage: Language = .russian, completion: @escaping (TranslationResult?, APIError?) -> Void) {
        translator.translate(text, from: sourceLanguage, to: targetLanguage) { (result, error) in
            completion(result, error)
        }
    }
    
}
