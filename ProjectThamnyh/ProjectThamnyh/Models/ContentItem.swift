//
//  ContentItem.swift
//  ProjectThamnyh
//
//  Created by Ibrahim MOHAMMED on 15/02/2026.
//

import Foundation

struct ContentItem: Decodable, Identifiable {
    let rawIdentifier: String
    let name: String
    let avatarURL: URL?
    let audioURL: String?
    let duration: Int?
    
    private let uuid = UUID()
    var id: UUID { uuid }
    
    enum CodingKeys: String, CodingKey {
        case podcast_id, episode_id, audiobook_id, article_id
        case name
        case avatar_url
        case audio_url
        case duration
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        
        if let pid = try? container.decode(String.self, forKey: .podcast_id) {
            self.rawIdentifier = pid
        } else if let eid = try? container.decode(String.self, forKey: .episode_id) {
            self.rawIdentifier = eid
        } else if let aid = try? container.decode(String.self, forKey: .audiobook_id) {
            self.rawIdentifier = aid
        } else if let arid = try? container.decode(String.self, forKey: .article_id) {
            self.rawIdentifier = arid
        } else {
            self.rawIdentifier = UUID().uuidString
        }
        
        if let urlString = try? container.decode(String.self, forKey: .avatar_url) {
            self.avatarURL = URL(string: urlString)
        } else {
            self.avatarURL = nil
        }
        
        if let aud = try? container.decode(String.self, forKey: .audio_url) {
            self.audioURL = aud
        } else {
            self.audioURL = nil
        }
        
        self.duration = try? container.decode(Int.self, forKey: .duration)
    }
}
