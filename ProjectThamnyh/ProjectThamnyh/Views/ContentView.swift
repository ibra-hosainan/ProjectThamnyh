//
//  ContentView.swift
//  ProjectThamnyh
//
//  Created by Ibrahim MOHAMMED on 15/02/2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = HomeViewModel()
    @StateObject private var audioPlayer = AudioPlayerManager.shared
    @State private var selectedCategory = 1
    @State private var showSearchView = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    HStack {
                        Image(systemName: "person.crop.circle.fill")
                            .foregroundStyle(.green)
                            .font(.system(size: 22))
                        
                        Text("Good Evening,Abdurahman 🌼")
                            .font(.system(size: 16, weight: .semibold))
                        
                        Spacer()
                        
                        Button(action: {
                            showSearchView = true
                        }) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                        }
                        
                        Image(systemName: "bell")
                            .font(.system(size: 18))
                    }
                    .padding(.horizontal)
                    .padding(.top)

                    CategoryChipsView(selected: $selectedCategory)

                    Group {
                        if viewModel.isLoading {
                            ProgressView("جاري التحميل …")
                                .progressViewStyle(CircularProgressViewStyle())
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else if let error = viewModel.errorMessage {
                            VStack(spacing: 10) {
                                Text("حدث خطأ")
                                Text(error).font(.caption2)
                                Button("إعادة المحاولة") { viewModel.load() }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            ScrollView {
                                LazyVStack(spacing: 28, pinnedViews: .sectionHeaders) {
                                    ForEach(viewModel.sections) { section in
                                        VStack(alignment: .leading, spacing: 8) {
                                            SectionHeader(title: section.name)
                                            SectionContent(section: section)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.bottom, audioPlayer.currentAudioURL != nil ? 70 : 0)
                            }
                        }
                    }
                    .onAppear { viewModel.load() }
                }
                
                // Mini player at the bottom
                if audioPlayer.currentAudioURL != nil {
                    MiniPlayerView(audioPlayer: audioPlayer)
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut, value: audioPlayer.currentAudioURL)
                }
            }
            .background(Color.black.ignoresSafeArea())
            .foregroundColor(.white)
        }
        .environment(\.layoutDirection, .leftToRight)
        .fullScreenCover(isPresented: $showSearchView) {
            SearchView()
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}

