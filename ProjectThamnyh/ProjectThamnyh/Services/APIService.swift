//
//  APIService.swift
//  ProjectThamnyh
//
//  Created by Ibrahim MOHAMMED on 15/02/2026.
//

import Foundation

class APIService {
    static let shared = APIService()
    private init() {}

    func fetchHomeSections() async throws -> [Section] {
        let url = URL(string: "https://api-v2-b2sit6oh3a-uc.a.run.app/home_sections")!
        let (data, _) = try await URLSession.shared.data(from: url)
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
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(SearchResponse.self, from: data)
        
        return decoded.sections.sorted { $0.order < $1.order }
    }
    
}
