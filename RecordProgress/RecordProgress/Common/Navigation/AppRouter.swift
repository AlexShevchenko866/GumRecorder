//
//  Untitled.swift
//  RecordProgress
//
//  Created by admin on 07.04.2026.
//
import SwiftUI

@Observable
@MainActor
class AppRouter {
    var path = NavigationPath()
    
    func navigate(to route: Route) {
        path.append(route)
    }
    
    func navigateBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func navigateToRoot() {
        path.removeLast(path.count)
    }
}
