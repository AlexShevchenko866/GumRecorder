//
//  ContentView.swift
//  RecordProgress
//
//  Created by admin on 02.03.2026.
//

import SwiftUI

struct ContentView: View {
    @State private var router = AppRouter()
    @Namespace private var namespace 
    
    var body: some View {
        NavigationStack(path: $router.path) {
                    HomeView()
                        .navigationDestination(for: Route.self) { route in
                            switch route {
                            case .calendar: CalendarView()
                                    .navigationTransition(.zoom(sourceID: "id", in: namespace))
                            case .addExercise: AddExerciseView()
                            }
                        }
                }
                .environment(router)
    }
    
}

#Preview {
    ContentView()
}


