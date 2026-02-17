//
//  SearchResultCard.swift
//  ProjectThamnyh
//
//  Created by Ibrahim MOHAMMED on 17/02/2026.
//

import SwiftUI

struct SearchResultCard: View {
    let item: SearchContentItem
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: item.avatarURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
            }
            .frame(width: 80, height: 80)
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(item.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                if let description = item.description {
                    Text(description)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .lineLimit(2)
                }
                
                HStack(spacing: 12) {
                    if let episodeCount = item.episodeCount {
                        HStack(spacing: 4) {
                            Image(systemName: "list.bullet")
                                .font(.system(size: 10))
                            Text("\(episodeCount) episodes")
                                .font(.system(size: 11))
                        }
                        .foregroundColor(.gray)
                    }
                    
                    if let duration = item.duration {
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.system(size: 10))
                            Text(formatDuration(duration))
                                .font(.system(size: 11))
                        }
                        .foregroundColor(.gray)
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
        .padding(12)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
    
    private func formatDuration(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}



