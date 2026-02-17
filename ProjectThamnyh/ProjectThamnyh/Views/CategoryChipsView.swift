//
//  CategoryChipsView.swift
//  ProjectThamnyh
//
//  Created by Ibrahim MOHAMMED on 15/02/2026.
//

import SwiftUI

struct CategoryChipsView: View {
    @Binding var selected: Int

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories.indices, id: \.self) { idx in
                    let isSelected = selected == idx
                    Text(categories[idx])
                        .font(.system(size: 14, weight: .semibold))
                        .padding(.vertical, 6)
                        .padding(.horizontal, 16)
                        .background(isSelected ? Color.red : Color(white: 0.15))
                        .clipShape(Capsule())
                        .foregroundColor(.white)
                        .onTapGesture { selected = idx }
                }
            }
            .padding(.horizontal)
        }
    }
}
