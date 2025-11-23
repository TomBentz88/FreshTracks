//
//  FreshTracksPlaylist.swift
//  FreshTracks
//
//  Created by Tom on 06/11/2025.
//

import Foundation
import MusicKit
import SwiftData

@Model
final class FreshTracksPlaylist {
    @Attribute(.unique) var id: UUID
    var tracksNumber: Int
    var appleMusicPlaylistId: MusicItemID?
    @Transient var refreshing: Bool = false
    var lastUpdateDate: Date?
    var url: URL?

    init(id: UUID = UUID(), tracksNumber: Int, appleMusicPlaylistId: MusicItemID? = nil, refreshing: Bool = true, lastUpdateDate: Date? = nil, url: URL? = nil) {
        self.id = id
        self.tracksNumber = tracksNumber
        self.appleMusicPlaylistId = appleMusicPlaylistId
        self.refreshing = refreshing
        self.lastUpdateDate = lastUpdateDate
        self.url = url
    }

    func appleMusicPlaylist() async throws -> Playlist {
        guard let appleMusicPlaylistId else {
            throw FreshTracksPlaylistError.noAppleMusicPlaylistId
        }
        var request = MusicLibraryRequest<Playlist>()
        request.filter(matching: \.id, equalTo: appleMusicPlaylistId)

        let response = try await request.response()

        guard let playlist = response.items.first else {
            throw FreshTracksPlaylistError.noAppleMusicPlaylistFound
        }
        let playlistWithTracks = try await playlist.with(.tracks)
        return playlistWithTracks
    }
}

enum FreshTracksPlaylistError: Error {
    case noAppleMusicPlaylistId
    case noAppleMusicPlaylistFound
}
