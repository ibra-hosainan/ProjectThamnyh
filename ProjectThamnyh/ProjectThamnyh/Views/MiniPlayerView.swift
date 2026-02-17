//
//  MiniPlayerView.swift
//  ProjectThamnyh
//
//  Created by Ibrahim MOHAMMED on 16/02/2026.
//

import SwiftUI

struct MiniPlayerView: View {
    @ObservedObject var audioPlayer: AudioPlayerManager
    
    private var formattedTime: String {
        let minutes = Int(audioPlayer.currentTime) / 60
        let seconds = Int(audioPlayer.currentTime) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    private var formattedDuration: String {
        let minutes = Int(audioPlayer.duration) / 60
        let seconds = Int(audioPlayer.duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 2)
                    
                    if audioPlayer.duration > 0 {
                        Rectangle()
                            .fill(Color.green)
                            .frame(width: geometry.size.width * CGFloat(audioPlayer.currentTime / audioPlayer.duration), height: 2)
                    }
                }
            }
            .frame(height: 2)
            
            // Player controls
            HStack(spacing: 12) {
                Button(action: {
                    if audioPlayer.isPlaying {
                        audioPlayer.pause()
                    } else if let url = audioPlayer.currentAudioURL {
                        audioPlayer.play(url: url)
                    }
                }) {
                    if audioPlayer.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(width: 44, height: 44)
                    } else {
                        Image(systemName: audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                    }
                }
                .disabled(audioPlayer.isLoading)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(audioPlayer.isLoading ? "جاري التحميل..." : "تشغيل الصوت")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                    
                    if !audioPlayer.isLoading {
                        Text("\(formattedTime) / \(formattedDuration)")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    audioPlayer.stop()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color(white: 0.12))
        }
        .background(Color.black)
    }
}

struct MiniPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        MiniPlayerView(audioPlayer: AudioPlayerManager.shared)
            .preferredColorScheme(.dark)
    }
}
