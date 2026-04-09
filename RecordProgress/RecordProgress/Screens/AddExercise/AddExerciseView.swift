//
//  AddExerciseView.swift
//  RecordProgress
//
//  Created by admin on 26.03.2026.
//

import SwiftUI
import SwiftfulRouting

struct AddExerciseView: View {
    var router: AnyRouter
    
    var body: some View {
        Text("Hello, World!")
            .onTapGesture {
                router.dismissScreen()
            }
    }
}
