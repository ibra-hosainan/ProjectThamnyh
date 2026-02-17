//
//  AudioPlayButton.swift
//  ProjectThamnyh
//
//  Created by Ibrahim MOHAMMED on 16/02/2026.
//

import SwiftUI

struct AudioPlayButton: View {
    let audioURL: String?
    let duration: Int?
    @ObservedObject var audioPlayer: AudioPlayerManager
    
    private var isCurrentlyPlaying: Bool {
        audioPlayer.currentAudioURL == audioURL && audioPlayer.isPlaying
    }
    
    private var isCurrentlyLoading: Bool {
        audioPlayer.currentAudioURL == audioURL && audioPlayer.isLoading
    }
    
    // Check if we have actual duration (from current play or cache)
    private var hasActualDuration: Bool {
        if audioPlayer.currentAudioURL == audioURL && audioPlayer.duration > 0 {
            return true
        }
        if let url = audioURL, audioPlayer.getCachedDuration(for: url) != nil {
            return true
        }
        return false
    }
    
    private var formattedDuration: String? {
        // If this audio is currently loaded, use the actual duration from player
        if audioPlayer.currentAudioURL == audioURL && audioPlayer.duration > 0 {
            let actualDuration = Int(audioPlayer.duration)
            let minutes = actualDuration / 60
            let seconds = actualDuration % 60
            return String(format: "%02d:%02d", minutes, seconds)
        }
        
        // Check if we have cached duration from previous playback
        if let url = audioURL, let cachedDuration = audioPlayer.getCachedDuration(for: url) {
            let actualDuration = Int(cachedDuration)
            let minutes = actualDuration / 60
            let seconds = actualDuration % 60
            return String(format: "%02d:%02d", minutes, seconds)
        }
        
        return nil
    }
    
    var body: some View {
        Button(action: {
            if let url = audioURL {
                audioPlayer.play(url: url)
            }
        }) {
            HStack(spacing: 6) {
               
                if isCurrentlyLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                        .frame(width: 16, height: 16)
                } else {
                    Image(systemName: isCurrentlyPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                }
                
                // Duration text - only show if we have actual duration
                if let duration = formattedDuration {
                    Text(duration)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Color(white: 0.2))
            )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(audioURL == nil)
        .opacity(audioURL == nil ? 0.5 : 1.0)
    }
}

struct AudioPlayButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            AudioPlayButton(audioURL: "test", duration: 300, audioPlayer: AudioPlayerManager.shared)
            AudioPlayButton(audioURL: "test", duration: 1800, audioPlayer: AudioPlayerManager.shared)
            AudioPlayButton(audioURL: nil, duration: 0, audioPlayer: AudioPlayerManager.shared)
        }
        .padding()
        .background(Color.black)
        .preferredColorScheme(.dark)
    }
}
