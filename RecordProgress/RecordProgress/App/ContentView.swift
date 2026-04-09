//
//  ContentView.swift
//  RecordProgress
//
//  Created by admin on 02.03.2026.
//

import SwiftUI
import SwiftfulRouting

struct ContentView: View {
    
    var body: some View {
        RouterView { router in
            HomeView(router: router)
        }
    }
    
}

#Preview {
    ContentView()
}


