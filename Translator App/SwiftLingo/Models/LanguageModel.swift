//
//  LanguageModel.swift
//  TranslateIt
//
//  Created by Heidy Veliz on 3/31/26.
//

import Foundation

struct LanguageModel: Identifiable, Hashable, Comparable, Codable {
    static func < (lhs: LanguageModel, rhs: LanguageModel) -> Bool {
        lhs.id < rhs.id
    }
    
    let id: String
    let flag: String
    let languageCode: String
    let ttsCode: String
}
