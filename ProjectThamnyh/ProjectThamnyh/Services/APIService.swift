//
//  APIService.swift
//  ProjectThamnyh
//
//  Created by Ibrahim MOHAMMED on 15/02/2026.
//

import SwiftUI

class APIService {
    static let shared = APIService()
    private init() {}

    func fetchHomeSections() async throws -> [Section] {
        let url = URL(string: "https://api-v2-b2sit6oh3a-uc.a.run.app/home_sections")!
        let (data, _) = try await URLSession.shared.data(from: url)
        print(data.count)
        let decoded = try JSONDecoder().decode(HomeSectionsResponse.self, from: data)
        return decoded.sections.sorted { $0.order < $1.order }
    }
    
    func searchWithDetails(query: String) async throws -> [SearchSection] {
        guard var urlComponents = URLComponents(string: "https://mock.apidog.com/m1/735111-711675-default/search") else {
            throw URLError(.badURL)
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: query)
        ]
        
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        
        print("🌐 API URL: \(url.absoluteString)")
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        print("📦 Data received: \(data.count) bytes")
        
        if let jsonString = String(data: data, encoding: .utf8) {
            print("📄 Search API Response: \(jsonString.prefix(500))...")
        }
        
        let decoded = try JSONDecoder().decode(SearchResponse.self, from: data)
        print("✅ Decoded \(decoded.sections.count) sections")
        
        return decoded.sections.sorted { $0.order < $1.order }
    }
    
}
