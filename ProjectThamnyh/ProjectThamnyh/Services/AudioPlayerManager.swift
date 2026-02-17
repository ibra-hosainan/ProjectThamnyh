//
//  AudioPlayerManager.swift
//  ProjectThamnyh
//
//  Created by Ibrahim MOHAMMED on 16/02/2026.
//

import Foundation
import AVFoundation
import Combine

class AudioPlayerManager: ObservableObject {
    static let shared = AudioPlayerManager()
    
    @Published var isPlaying = false
    @Published var isLoading = false
    @Published var currentAudioURL: String?
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    @Published var playbackError: String?
    
    private var player: AVPlayer?
    private var timeObserver: Any?
    private var statusObservation: NSKeyValueObservation?
    private var playerItemStatusObservation: NSKeyValueObservation?
    
    // Cache actual durations for URLs
    private var durationCache: [String: TimeInterval] = [:]
    
    private init() {
        setupAudioSession()
    }
    
    // Get cached duration for a URL
    func getCachedDuration(for url: String) -> TimeInterval? {
        return durationCache[url]
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    func play(url: String) {
        // If same URL and already playing, pause it
        if currentAudioURL == url && isPlaying {
            pause()
            return
        }
        
        // If same URL but paused, resume
        if currentAudioURL == url && !isPlaying {
            player?.play()
            isPlaying = true
            isLoading = false
            return
        }
        
        // If different URL, stop current and play new
        if currentAudioURL != url {
            cleanupPlayer()
            
            guard let audioURL = URL(string: url) else {
                playbackError = "Invalid audio URL"
                isLoading = false
                return
            }
            
            currentAudioURL = url
            isLoading = true
            
            let playerItem = AVPlayerItem(url: audioURL)
            player = AVPlayer(playerItem: playerItem)
            
            setupObservers()
            addPeriodicTimeObserver()
        }
        
        playbackError = nil
    }
    
    func pause() {
        player?.pause()
        isPlaying = false
        isLoading = false
    }
    
    func stop() {
        cleanupPlayer()
        currentAudioURL = nil
        isPlaying = false
        isLoading = false
        currentTime = 0
        duration = 0
    }
    
    func seek(to time: TimeInterval) {
        let cmTime = CMTime(seconds: time, preferredTimescale: 600)
        player?.seek(to: cmTime)
    }
    
    private func setupObservers() {
        // Observe player item status
        playerItemStatusObservation = player?.currentItem?.observe(\.status, options: [.new, .initial]) { [weak self] item, _ in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch item.status {
                case .failed:
                    self.playbackError = "Failed to load audio"
                    self.isPlaying = false
                    self.isLoading = false
                case .readyToPlay:
                    self.playbackError = nil
                    self.isLoading = false
                    // Auto-play when ready
                    self.player?.play()
                    self.isPlaying = true
                case .unknown:
                    break
                @unknown default:
                    break
                }
            }
        }
        
        // Observe when item finishes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem
        )
    }
    
    @objc private func playerDidFinishPlaying() {
        DispatchQueue.main.async { [weak self] in
            self?.isPlaying = false
            self?.currentTime = 0
            self?.player?.seek(to: .zero)
        }
    }
    
    private func addPeriodicTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: 600)
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self else { return }
            self.currentTime = time.seconds
            
            if let duration = self.player?.currentItem?.duration.seconds, !duration.isNaN {
                self.duration = duration
                
                // Cache the actual duration
                if let url = self.currentAudioURL {
                    self.durationCache[url] = duration
                }
            }
        }
    }
    
    private func removePeriodicTimeObserver() {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
    }
    
    private func cleanupPlayer() {
        player?.pause()
        removePeriodicTimeObserver()
        statusObservation?.invalidate()
        statusObservation = nil
        playerItemStatusObservation?.invalidate()
        playerItemStatusObservation = nil
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        player = nil
    }
    
    deinit {
        cleanupPlayer()
        NotificationCenter.default.removeObserver(self)
    }
}
