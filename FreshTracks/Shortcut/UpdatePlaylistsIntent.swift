//
//  UpdatePlaylistsIntent.swift
//  FreshTracks
//
//  Created by Tom on 16/05/2025.
//

import AppIntents
import SwiftData

struct UpdatePlaylistsIntent: AppIntent {    
    static var title: LocalizedStringResource = "Update FreshTracks playlists"
    static var description = IntentDescription("Update all the playlists with the last tracks from the library")

    static var suggestedInvocationPhrase: String? = "Mets à jour FreshTracks"

    func perform() async throws -> some IntentResult {
        let container = try ModelContainer(for: FreshTracksPlaylist.self)
        let context = await container.mainContext
        try await FreshTracksViewModel(context: context).refreshAllPlaylists()
        return .result()
    }
}

