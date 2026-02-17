//
//  FilterChip.swift
//  ProjectThamnyh
//
//  Created by Ibrahim MOHAMMED on 17/02/2026.
//

import SwiftUI

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? .black : .white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.green : Color.white.opacity(0.1))
                )
        }
    }
}

struct FilterChip_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 8) {
            FilterChip(title: "الكل", isSelected: true, action: {})
            FilterChip(title: "بودكاست", isSelected: false, action: {})
            FilterChip(title: "حلقات", isSelected: false, action: {})
        }
        .padding()
        .background(Color.black)
        .preferredColorScheme(.dark)
    }
}
