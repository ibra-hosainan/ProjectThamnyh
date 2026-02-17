//
//  SectionHeader.swift
//  ProjectThamnyh
//
//  Created by Ibrahim MOHAMMED on 15/02/2026.
//

import SwiftUI

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        HStack(spacing: 8) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
}
