//
//  HomeView.swift
//  RecordProgress
//
//  Created by admin on 07.04.2026.
//

import SwiftUI

struct HomeView: View {
    @Environment(AppRouter.self) private var router
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Screen for animation")
                .font(.body.bold())
                .frame(maxWidth: .infinity, alignment: .center)
            Button {
                router.navigate(to: .calendar)
            } label: {
                Label("Go Next", systemImage: "house.fill")
                    .font(.body.bold())
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}
