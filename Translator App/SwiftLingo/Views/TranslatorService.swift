//
//  TranslatorService.swift
//  SwiftLingo
//
//  Created by Heidy Veliz on 3/31/26.
//

import Foundation

struct MyMemoryResponse: Codable {
    let responseData: ResponseData
}

struct ResponseData: Codable {
    let translatedText: String
}

class TranslationService {
    func translate(text: String, completion: @escaping (Result<String, Error>) -> Void) {
        let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.mymemory.translated.net/get?q=\(encodedText)&langpair=en|es"

        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "BadURL", code: 0)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "NoData", code: 0)))
                }
                return
            }

            do {
                let decoded = try JSONDecoder().decode(MyMemoryResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decoded.responseData.translatedText))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
