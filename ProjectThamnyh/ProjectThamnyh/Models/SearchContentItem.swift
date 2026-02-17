//
//  SearchContentItem.swift
//  ProjectThamnyh
//
//  Created by Ibrahim MOHAMMED on 17/02/2026.
//

import SwiftUI

struct SearchContentItem: Decodable, Identifiable {
    let rawIdentifier: String
    let name: String
    let description: String?
    let avatarURL: URL?
    let duration: Int?
    let episodeCount: Int?
    let language: String?
    let priority: String?
    let popularityScore: String?
    let score: String?
    
    private let uuid = UUID()
    var id: UUID { uuid }
    
    enum CodingKeys: String, CodingKey {
        case podcast_id
        case name
        case description
        case avatar_url
        case duration
        case episode_count
        case language
        case priority
        case popularityScore
        case score
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try? container.decode(String.self, forKey: .description)
        self.language = try? container.decode(String.self, forKey: .language)
        self.priority = try? container.decode(String.self, forKey: .priority)
        self.popularityScore = try? container.decode(String.self, forKey: .popularityScore)
        self.score = try? container.decode(String.self, forKey: .score)
        
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
    
    func toContentItem() -> ContentItem {
        var tempData: [String: Any] = [
            "podcast_id": self.rawIdentifier,
            "name": self.name
        ]
        
        if let avatarURL = self.avatarURL?.absoluteString {
            tempData["avatar_url"] = avatarURL
        }
        
        if let duration = self.duration {
            tempData["duration"] = duration
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: tempData)
            let contentItem = try JSONDecoder().decode(ContentItem.self, from: jsonData)
            return contentItem
        } catch {
            print("Error converting SearchContentItem to ContentItem: \(error)")
            fatalError("Failed to convert SearchContentItem to ContentItem")
        }
    }
}
