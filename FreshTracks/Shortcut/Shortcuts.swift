//
//  Shortcuts.swift
//  FreshTracks
//
//  Created by Tom on 05/10/2025.
//

import AppIntents

struct FreshTracksShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: UpdatePlaylistsIntent(),
            phrases: [
                "Met à jour \(.applicationName)",
                "Rafraîchir mes playlists \(.applicationName)",
                "Actualiser \(.applicationName)"
            ],
            shortTitle: "Rafraîchir FreshTracks",
            systemImageName: "music.note.list"
        )
    }
}
