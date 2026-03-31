//
//  FirestoreManager.swift
//  SwiftLingo
//
//  Created by Heidy Veliz on 3/31/26.
//

import Foundation
import FirebaseFirestore

struct TranslationRecord: Identifiable {
    var id: String
    var originalText: String
    var translatedText: String
    var timestamp: Date
}

class FirestoreManager: ObservableObject {
    @Published var history: [TranslationRecord] = []

    private let db = Firestore.firestore()

    func saveTranslation(original: String, translated: String) {
        let data: [String: Any] = [
            "originalText": original,
            "translatedText": translated,
            "timestamp": Timestamp(date: Date())
        ]

        db.collection("translations").addDocument(data: data) { error in
            if let error = error {
                print("Save error: \(error.localizedDescription)")
            } else {
                self.fetchHistory()
            }
        }
    }

    func fetchHistory() {
        db.collection("translations")
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Fetch error: \(error.localizedDescription)")
                    return
                }

                self.history = snapshot?.documents.compactMap { doc in
                    let data = doc.data()
                    return TranslationRecord(
                        id: doc.documentID,
                        originalText: data["originalText"] as? String ?? "",
                        translatedText: data["translatedText"] as? String ?? "",
                        timestamp: (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
                    )
                } ?? []
            }
    }

    func clearHistory() {
        db.collection("translations").getDocuments { snapshot, error in
            if let error = error {
                print("Clear error: \(error.localizedDescription)")
                return
            }

            snapshot?.documents.forEach { $0.reference.delete() }

            DispatchQueue.main.async {
                self.history = []
            }
        }
    }
}
