//
//  SearchContentItem.swift
//  ProjectThamnyh
//
//  Created by Ibrahim MOHAMMED on 17/02/2026.
//

import Foundation

struct SearchContentItem: Decodable, Identifiable {
    let rawIdentifier: String
    let name: String
    let description: String?
    let avatarURL: URL?
    let duration: Int?
    let episodeCount: Int?
    
    private let uuid = UUID()
    var id: UUID { uuid }
    
    enum CodingKeys: String, CodingKey {
        case podcast_id
        case name
        case description
        case avatar_url
        case duration
        case episode_count
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try? container.decode(String.self, forKey: .description)
        
        if let pid = try? container.decode(String.self, forKey: .podcast_id) {
            self.rawIdentifier = pid
        } else {
            self.rawIdentifier = UUID().uuidString
        }
        
      
        if let urlString = try? container.decode(String.self, forKey: .avatar_url) {
            self.avatarURL = URL(string: urlString)
        } else {
            self.avatarURL = nil
        }
        
        if let durationInt = try? container.decode(Int.self, forKey: .duration) {
            self.duration = durationInt
        } else if let durationString = try? container.decode(String.self, forKey: .duration) {
            self.duration = Int(durationString)
        } else {
            self.duration = nil
        }
        
        if let countInt = try? container.decode(Int.self, forKey: .episode_count) {
            self.episodeCount = countInt
        } else if let countString = try? container.decode(String.self, forKey: .episode_count) {
            self.episodeCount = Int(countString)
        } else {
            self.episodeCount = nil
        }
    }
}
