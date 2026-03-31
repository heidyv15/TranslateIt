//
//  SwiftLingoApp.swift
//  TranslateIt
//
//  Created by Heidy Veliz on 3/31/26.
//

import SwiftUI
import FirebaseCore

@main
struct SwiftLingoApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
