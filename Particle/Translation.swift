//
//  Translation.swift
//  Particle
//
//  Created by Artem Misesin on 4/9/18.
//  Copyright © 2018 Artem Misesin. All rights reserved.
//

import Foundation

struct TranslationResult: Codable {
    
    var definitions: [Definition] = []
    
    enum CodingKeys: String, CodingKey {
        case definitions = "def"
    }
    
}

struct Definition: Codable {

    var partOfSpeech: String?
    var text: String?
    var translations: [EntireTranslation] = []
    var transcription: String?

    enum CodingKeys: String, CodingKey {
        case partOfSpeech = "pos"
        case translations = "tr"
        case transcription = "ts"
        case text = "text"
    }
}

struct EntireTranslation: Codable {
    
    var examples: [Example]?
    var gender: String?
    var meaning: [Meaning]?
    var synonyms: [Synonym]?
    var text: String?
    var partOfSpeech: String?
    
    enum CodingKeys: String, CodingKey {
        case examples = "ex"
        case gender = "gen"
        case meaning = "mean"
        case synonyms = "syn"
        case partOfSpeech = "pos"
        case text = "text"
    }
    
}

struct Translation: Codable {
    var text: String?
}

struct Example: Codable {
    var text: String?
    var number: String?
    var translations: [Translation]?
    
    enum CodingKeys: String, CodingKey {
        case text = "text"
        case translations = "tr"
        case number = "num"
    }
}

struct Meaning: Codable {
    var text: String?
}

struct Synonym: Codable {
    var text: String?
    var partOfSpeech: String?
    var gender: String?
    var number: String?

    enum CodingKeys: String, CodingKey {
        case partOfSpeech = "pos"
        case text = "text"
        case gender = "gen"
        case number = "num"
    }
}
