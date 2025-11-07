//
//  FreshTracksPlaylistsStore.swift
//  FreshTracks
//
//  Created by Tom on 03/11/2025.
//

import Foundation

@Observable
final class FreshTracksPlaylistsStore {

    private let storageKey = "freshtracks.playlists"


    private(set) var playlists: [FreshTracksPlaylist] = [] {
        didSet {
            savePlaylists()
        }
    }

    init() {
        loadPlaylists()
    }

    func add(_ playlist: FreshTracksPlaylist) {
        playlists.append(playlist)
    }

    func update(withId id: UUID, updates: (inout FreshTracksPlaylist) -> Void) {
        if let index = playlists.firstIndex(where: { $0.id == id }) {
            updates(&playlists[index])
        }
    }

    func remove(withId id: UUID) {
        playlists.removeAll { $0.id == id }
    }

    private func savePlaylists() {
        if let data = try? JSONEncoder().encode(playlists) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    public func loadPlaylists() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([FreshTracksPlaylist].self, from: data)
        else { return }
        playlists = decoded
    }
}
