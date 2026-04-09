//
//  HomeView.swift
//  RecordProgress
//
//  Created by admin on 07.04.2026.
//

import SwiftUI
import SwiftfulRouting

struct HomeView: View {
    var router: AnyRouter
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Screen for animation")
                .font(.body.bold())
                .frame(maxWidth: .infinity, alignment: .center)
            Button {
                router.showScreen(.push) { router in
                    CalendarView(router: router)
                }
            } label: {
                Label("Go Next", systemImage: "house.fill")
                    .font(.body.bold())
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}
