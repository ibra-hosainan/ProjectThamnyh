//
//  SearchView.swift
//  ProjectThamnyh
//
//  Created by Ibrahim MOHAMMED on 17/02/2026.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @Environment(\.dismiss) var dismiss
    @FocusState private var isSearchFieldFocused: Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .font(.system(size: 16))
                        
                        ZStack(alignment: .leading) {
                            if viewModel.searchText.isEmpty {
                                Text("ابحث عن اي محتوى...")
                                    .foregroundColor(.white.opacity(0.5))
                                    .allowsHitTesting(false)
                            }
                            TextField("", text: $viewModel.searchText)
                                .textFieldStyle(.plain)
                                .foregroundColor(.white)
                                .focused($isSearchFieldFocused)
                                .submitLabel(.search)
                        }
                        
                        if !viewModel.searchText.isEmpty {
                            Button(action: {
                                viewModel.clearSearch()
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 16))
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                    
                    Button("إلغاء") {
                        dismiss()
                    }
                    .foregroundColor(.green)
                    .font(.system(size: 16))
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
                .background(Color.black)
                
                Divider()
                    .background(Color.white.opacity(0.1))
                
                Group {
                    if viewModel.searchText.isEmpty {
                        emptySearchView
                    } else if viewModel.isLoading {
                        loadingView
                    } else if let error = viewModel.errorMessage {
                        errorView(error: error)
                    } else if viewModel.searchResults.isEmpty {
                        noResultsView
                    } else {
                        searchResultsView
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(Color.black.ignoresSafeArea())
            .foregroundColor(.white)
        }
        .environment(\.layoutDirection, .leftToRight)
        .onAppear {
            isSearchFieldFocused = true
        }
    }
    
    // MARK: - Empty Search View
    private var emptySearchView: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("ابحث عن المحتوى المفضل لديك")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.gray)
            
            Text("اكتب في شريط البحث أعلاه للعثور على البودكاست، الحلقات، الكتب الصوتية والمزيد")
                .font(.system(size: 14))
                .foregroundColor(.gray.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .green))
                .scaleEffect(1.5)
            
            Text("جاري البحث...")
                .font(.system(size: 16))
                .foregroundColor(.gray)
        }
    }
    
    // MARK: - Error View
    private func errorView(error: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundColor(.red.opacity(0.7))
            
            Text("حدث خطأ")
                .font(.system(size: 18, weight: .semibold))
            
            Text(error)
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button("إعادة المحاولة") {
                viewModel.performSearch(query: viewModel.searchText)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
    
    // MARK: - No Results View
    private var noResultsView: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("لا توجد نتائج")
                .font(.system(size: 18, weight: .semibold))
            
            Text("لم نتمكن من العثور على نتائج لـ \"\(viewModel.searchText)\"")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
    
    // MARK: - Search Results View
    private var searchResultsView: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(viewModel.searchResults) { item in
                    SearchResultCard(item: item)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 16)
        }
    }
}

// MARK: - Preview
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .preferredColorScheme(.dark)
    }
}
