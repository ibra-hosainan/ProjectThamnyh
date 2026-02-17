//
//  Section.swift
//  ProjectThamnyh
//
//  Created by Ibrahim MOHAMMED on 15/02/2026.
//

import SwiftUI

struct Section: Decodable, Identifiable {
    let id = UUID()
    let name: String
    let type: String
    let content_type: String
    let order: Int
    let content: [ContentItem]
}
