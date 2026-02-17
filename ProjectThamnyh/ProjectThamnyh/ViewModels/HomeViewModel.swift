//
//  HomeViewModel.swift
//  ProjectThamnyh
//
//  Created by Ibrahim MOHAMMED on 15/02/2026.
//


import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var sections: [Section] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func load() {
        Task {
            do {
                isLoading = true
                sections = try await APIService.shared.fetchHomeSections()
                isLoading = false
            } catch {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
}
