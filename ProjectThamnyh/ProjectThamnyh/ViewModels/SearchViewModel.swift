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
    @Published var sections: [Section] = []
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
            sections = []
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
                
                print("🔍 Search Query: \(query)")
                print("📦 Total Sections Received: \(searchSections.count)")
                
                let allItems = searchSections.flatMap { $0.content }
                print("📦 Total Items Before Filter: \(allItems.count)")
                
                searchResults = allItems.filter { item in
                    let searchQuery = query.lowercased()
                    
                    let matchesName = item.name.lowercased().contains(searchQuery)
                    
                    let matchesDescription = item.description?.lowercased().contains(searchQuery) ?? false
                    
                    let matches = matchesName || matchesDescription
                    
                    if matches {
                        print("   ✅ Match: '\(item.name)'")
                    }
                    
                    return matches
                }
                
                print("📋 Total Results After Filter: \(searchResults.count)")
                
                sections = searchSections.map { $0.toSection() }
                
                isLoading = false
            } catch is CancellationError {
                isLoading = false
            } catch {
                errorMessage = error.localizedDescription
                isLoading = false
                sections = []
                searchResults = []
            }
        }
    }
    
    func clearSearch() {
        searchText = ""
        sections = []
        searchResults = []
        errorMessage = nil
    }
}
