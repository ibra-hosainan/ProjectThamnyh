//
//  SquareCard.swift
//  ProjectThamnyh
//
//  Created by Ibrahim MOHAMMED on 15/02/2026.
//

import SwiftUI


struct SquareCard: View {
    let item: ContentItem
    var big: Bool = false
    
    @StateObject private var audioPlayer = AudioPlayerManager.shared
    
    private var side: CGFloat { big ? 180 : 120 }
    private var hasAudio: Bool { 
        item.audioURL != nil && !item.audioURL!.isEmpty 
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: item.avatarURL) { phase in
                switch phase {
                case .success(let image):
                    image.resizable()
                default:
                    Color.gray
                }
            }
            .aspectRatio(1, contentMode: .fill)
            .frame(width: side, height: side)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.system(size: 14, weight: .semibold))
                    .lineLimit(2)
                    .frame(width: side, alignment: .leading)
                
                if hasAudio {
                    AudioPlayButton(
                        audioURL: item.audioURL,
                        audioPlayer: audioPlayer
                    )
                }
            }
        }
        .frame(width: side)
    }
}
