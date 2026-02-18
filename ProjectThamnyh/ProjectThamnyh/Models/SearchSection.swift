//
//  SearchSection.swift
//  ProjectThamnyh
//
//  Created by Ibrahim MOHAMMED on 17/02/2026.
//

import Foundation

struct SearchSection: Decodable, Identifiable {
    let id = UUID()
    let name: String
    let type: String
    let content_type: String
    let order: Int
    let content: [SearchContentItem]
    
    enum CodingKeys: String, CodingKey {
        case name, type, content_type, order, content
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.type = try container.decode(String.self, forKey: .type)
        self.content_type = try container.decode(String.self, forKey: .content_type)
        self.content = try container.decode([SearchContentItem].self, forKey: .content)
        
        if let orderInt = try? container.decode(Int.self, forKey: .order) {
            self.order = orderInt
        } else if let orderString = try? container.decode(String.self, forKey: .order) {
            self.order = Int(orderString) ?? 0
        } else {
            self.order = 0
        }
    }
}
