//
//  FreshTracksViewModel.swift
//  FreshTracks
//
//  Created by Tom on 14/02/2025.
//

import Foundation
import MusicKit
import UIKit
import SwiftUI


final class FreshTracksViewModel: ObservableObject {

    private let storageKey = "freshtracks.playlists"

    var store = FreshTracksPlaylistsStore()

    private var missingPlaylists = [FreshTracksPlaylist]()


    @Published var alert: FreshTracksAlert?

    init() {
        Task {
            try? await syncPlaylists()
        }
    }

    func requestAppleMusicAccess() async -> Bool {
        let status = await MusicAuthorization.request()
        return status == .authorized
    }

    func createAppleMusicPlaylist(_ playlist: FreshTracksPlaylist) async throws {
        await requestAppleMusicAccess()
        let songs = try await fetchRecentSongs(limit: playlist.tracksNumber)
        let appleMusicPlaylist = try await addSoundsToPlaylist(named: "Fresh Tracks \(playlist.tracksNumber)", songs: songs)
        store.update(withId: playlist.id) { ftPlaylist in
            ftPlaylist.refreshing = false
            ftPlaylist.appleMusicPlaylistId = appleMusicPlaylist.id
            ftPlaylist.lastUpdateDate = Date()
        }
    }

    public func openAppleMusicPlaylist(_ playlist: FreshTracksPlaylist) async throws {
        let playlistsRequest = MusicLibraryRequest<Playlist>()
        let response = try await playlistsRequest.response()

        if let appleMusicPlaylist = response.items.first(where: { $0.id == playlist.appleMusicPlaylistId }) {
            DispatchQueue.main.async {
                UIApplication.shared.open(appleMusicPlaylist.url!)
            }
        } else {

        }
    }

    // Fonction pour récupérer les X derniers morceaux ajoutés
    func fetchRecentSongs(limit: Int) async throws -> [Song] {
        let request = MusicLibraryRequest<Song>()
        let response = try await request.response()
        let sortedSongs = response.items.sorted { $0.libraryAddedDate ?? Date.distantPast > $1.libraryAddedDate ?? Date.distantPast }
        return Array(sortedSongs.prefix(limit))
    }

    private func addSoundsToPlaylist(named playlistName: String, songs: [Song]) async throws -> Playlist {
        let playlistsRequest = MusicLibraryRequest<Playlist>()
        let response = try await playlistsRequest.response()

        if let existingPlaylist = response.items.first(where: { $0.name == playlistName }) {
            return try await MusicLibrary.shared.edit(existingPlaylist, items: songs)
        } else {
            return try await MusicLibrary.shared.createPlaylist(name: playlistName, items: songs)
        }
    }

    public func updateAllPlaylists() async throws {
        if store.playlists.count == 0 {
            store.loadPlaylists()
        }
        for playlist in store.playlists {
            try await createAppleMusicPlaylist(playlist)
        }
    }

    func addPlaylist(tracksNumber: Int) -> Result<Void, PlaylistError> {
        if store.playlists.contains(where: { $0.tracksNumber == tracksNumber }) {
            return .failure(.alreadyExists)
        }
        let playlist = FreshTracksPlaylist(tracksNumber: tracksNumber)
        store.add(playlist)
        Task {
            do {
                try await createAppleMusicPlaylist(playlist)
            } catch { print(error) }
        }
        return .success(())
    }

    private func syncPlaylists() async throws {
        let playlistsRequest = MusicLibraryRequest<Playlist>()
        let response = try await playlistsRequest.response()

        for storedPlaylist in store.playlists {

            guard let appleMusicPlaylistId = storedPlaylist.appleMusicPlaylistId else {
                break
            }
            if let appleMusicPlaylist = response.items.first(where: { $0.id == appleMusicPlaylistId }) {
                // playlist exists
            } else {
                // la playlist apple music n'existe pas : informer l'utilisateur, lui proposer de la recréer, sinon supprimer la playlist fresh tracks
                missingPlaylists.append(storedPlaylist)
            }
        }

        if missingPlaylists.count > 0 {
            alert = FreshTracksAlert(type: .recreateMissingPlaylist, message: "Some playlists might have been deleted from Apple Music, do you want to recreate them ?")
        }
    }

    public func recreateMissingPlaylists() {
        for playlist in missingPlaylists {
            Task {
                do {
                    try await createAppleMusicPlaylist(playlist)
                } catch {
                    // TODO: handle and display error
                }
            }
        }
    }

    public func eraseMissingPlaylists() {
        for playlist in missingPlaylists {
            store.remove(withId: playlist.id)
        }
    }
}


