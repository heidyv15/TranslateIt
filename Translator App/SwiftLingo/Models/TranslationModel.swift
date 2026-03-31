//
//  TranslationModel.swift
//  TranslateIt
//
//  Created by Heidy Veliz on 3/31/26.
//

import Foundation

struct TranslationModel: Identifiable, Codable, Comparable {
    static func < (lhs: TranslationModel, rhs: TranslationModel) -> Bool {
        lhs.id > rhs.id
    }
    
    let id: Double
    let sourceLanguage: LanguageModel
    let targetLanguage: LanguageModel
    let textToTranslate: String
    let translation: String
}
