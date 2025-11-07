//
//  FreshTracksPlaylist.swift
//  FreshTracks
//
//  Created by Tom on 06/11/2025.
//

import Foundation
import MusicKit

public struct FreshTracksPlaylist: Identifiable, Codable {
    public var id = UUID()
    public var tracksNumber: Int
    public var appleMusicPlaylistId: MusicItemID?
    public var refreshing: Bool = true
    public var lastUpdateDate: Date?
}
