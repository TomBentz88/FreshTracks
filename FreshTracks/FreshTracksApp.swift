//
//  FreshTracksApp.swift
//  FreshTracks
//
//  Created by Tom on 14/02/2025.
//

import SwiftData
import SwiftUI

@main
struct FreshTracksApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: FreshTracksPlaylist.self)
    }
}
