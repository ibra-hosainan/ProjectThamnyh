//
//  ProjectThamnyhTests.swift
//  ProjectThamnyhTests
//
//  Created by Ibrahim MOHAMMED on 15/02/2026.
//

import Testing
@testable import ProjectThamnyh
import Foundation
import Combine

struct ProjectThamnyhTests {

    @Test @MainActor func debounce200MillisecondsEmitsAfterQuietPeriod() async throws {
        let subject = PassthroughSubject<String, Never>()
        var received: [String] = []

        let cancel = subject
            .debounce(for: .milliseconds(200), scheduler: DispatchQueue.main)
            .sink { received.append($0) }

        subject.send("a")
        subject.send("ab")
        subject.send("abc")

        try await Task.sleep(for: .milliseconds(250))

        cancel.cancel()

        #expect(received == ["abc"], "Debounce(200ms) should emit only last value after 200ms quiet")
    }

    @Test func searchContentItemDecodesJSON() throws {
        let json = """
        {
            "podcast_id": "abc123",
            "name": "Test Podcast",
            "description": "A sample podcast",
            "avatar_url": "https://example.com/image.png",
            "duration": 3600,
            "episode_count": 10
        }
        """.data(using: .utf8)!

        let item = try JSONDecoder().decode(SearchContentItem.self, from: json)

        #expect(item.rawIdentifier == "abc123")
        #expect(item.name == "Test Podcast")
        #expect(item.description == "A sample podcast")
        #expect(item.avatarURL?.absoluteString == "https://example.com/image.png")
        #expect(item.duration == 3600)
        #expect(item.episodeCount == 10)
    }
    

}
