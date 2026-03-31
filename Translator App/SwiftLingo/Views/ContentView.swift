//
//  ContentView.swift
//  TranslateIt
//
//  Created by Heidy Veliz on 3/31/26.
//

import SwiftUI

struct LocalTranslationRecord: Identifiable {
    let id = UUID()
    let originalText: String
    let translatedText: String
}

struct ContentView: View {
    @State private var inputText = ""
    @State private var translatedText = ""
    @State private var history: [LocalTranslationRecord] = []
    @State private var isLoading = false

    let translator = TranslationService()

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("TranslateMe")
                    .font(.largeTitle)
                    .bold()

                TextField("Enter text here", text: $inputText)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                Button(action: translateText) {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Translate")
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)

                TextField("Translation appears here", text: $translatedText)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                    .disabled(true)

                HStack {
                    Text("History")
                        .font(.headline)

                    Spacer()

                    Button("Clear History") {
                        history.removeAll()
                    }
                    .foregroundColor(.red)
                }
                .padding(.horizontal)

                List(history) { item in
                    VStack(alignment: .leading) {
                        Text("Original: \(item.originalText)")
                        Text("Translated: \(item.translatedText)")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }

    func translateText() {
        guard !inputText.isEmpty else { return }

        isLoading = true

        translator.translate(text: inputText) { result in
            isLoading = false

            switch result {
            case .success(let translated):
                translatedText = translated
                history.insert(
                    LocalTranslationRecord(
                        originalText: inputText,
                        translatedText: translated
                    ),
                    at: 0
                )

            case .failure:
                translatedText = "Error"
            }
        }
    }
}
