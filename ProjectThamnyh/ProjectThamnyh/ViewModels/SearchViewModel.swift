//
//  SearchViewModel.swift
//  ProjectThamnyh
//
//  Created by Ibrahim MOHAMMED on 17/02/2026.
//

import SwiftUI
import Combine

@MainActor
class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var searchResults: [SearchContentItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private var searchTask: Task<Void, Never>?
    
    init() {
        setupSearchDebounce()
    }
    
    private func setupSearchDebounce() {
        $searchText
            .debounce(for: .milliseconds(200), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchQuery in
                self?.performSearch(query: searchQuery)
            }
            .store(in: &cancellables)
    }
    
    func performSearch(query: String) {
      
        searchTask?.cancel()
        
       
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            searchResults = []
            errorMessage = nil
            return
        }
        
        searchTask = Task {
            do {
                isLoading = true
                errorMessage = nil
                
                try Task.checkCancellation()
                
                let searchSections = try await APIService.shared.searchWithDetails(query: query)
                let allItems = searchSections.flatMap { $0.content }
                
                searchResults = allItems.filter { item in
                    let searchQuery = query.lowercased()
                    let matchesName = item.name.lowercased().contains(searchQuery)
                    let matchesDescription = item.description?.lowercased().contains(searchQuery) ?? false
                    return matchesName || matchesDescription
                }
                
                isLoading = false
            } catch is CancellationError {
                isLoading = false
            } catch {
                errorMessage = error.localizedDescription
                isLoading = false
                searchResults = []
            }
        }
    }
    
    func clearSearch() {
        searchText = ""
        searchResults = []
        errorMessage = nil
    }
}
