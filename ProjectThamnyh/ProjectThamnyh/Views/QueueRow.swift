//
//  QueueRow.swift
//  ProjectThamnyh
//
//  Created by Ibrahim MOHAMMED on 15/02/2026.
//

import SwiftUI

struct QueueRow: View {
    let item: ContentItem
    @StateObject private var audioPlayer = AudioPlayerManager.shared

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: item.avatarURL) { phase in
                switch phase {
                case .success(let image):
                    image.resizable()
                default:
                    Color.gray
                }
            }
            .aspectRatio(1, contentMode: .fill)
            .frame(width: 64, height: 64)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.system(size: 15, weight: .medium))
                    .lineLimit(2)
                    .foregroundColor(.white)
                
                // Use the same audio button design
                if item.audioURL != nil {
                    AudioPlayButton(
                        audioURL: item.audioURL,
                        audioPlayer: audioPlayer
                    )
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(white: 0.12)))
    }
}
