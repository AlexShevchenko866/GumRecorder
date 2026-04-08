//
//  RecordProgressApp.swift
//  RecordProgress
//
//  Created by admin on 02.03.2026.
//

import SwiftUI

@main
struct RecordProgressApp: App {
    @State private var router = AppRouter()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(router)
        }
    }
}
