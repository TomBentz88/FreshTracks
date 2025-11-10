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
    var refreshing: Bool
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
}
