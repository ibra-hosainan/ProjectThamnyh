//
//  SectionContent.swift
//  ProjectThamnyh
//
//  Created by Ibrahim MOHAMMED on 15/02/2026.
//

import SwiftUI


struct SectionContent: View {
    let section: Section

    var body: some View {
        switch section.type.lowercased() {
        case "square":
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(section.content) { item in
                        SquareCard(item: item, contentType: section.content_type)
                    }
                }
            }
        case "2_lines_grid":
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(section.content) { item in
                       SquareCard(item: item, contentType: section.content_type)
                    }
                }
            }
        case "big_square","big square":
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(section.content) { item in
                        SquareCard(item: item, big: true, contentType: section.content_type)
                     
                    }
                }
            }
            
        case "queue":
            VStack(spacing: 10) {
                ForEach(section.content) { item in
                    QueueRow(item: item)
                }
            
            }
        default:
            EmptyView()
        }
    }
}

