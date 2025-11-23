//
//  PlaylistDetailView.swift
//  FreshTracks
//
//  Created by Tom on 23/11/2025.
//

import Foundation
import MusicKit
import SwiftUI

struct PlaylistDetailView: View {
    let playlist: Playlist
    
    var body: some View {
        List {
            ForEach(playlist.tracks ?? []) { track in
                TrackRow(track: track)
            }
        }
        .navigationTitle(playlist.name)
    }
}

struct TrackRow: View {
    let track: Track

    var body: some View {
        HStack {
            AsyncImage(url: track.artwork?.url(width: 100, height: 100))
            VStack(alignment: .leading) {
                Text(track.title)
                Text(track.artistName)
            }
        }
    }
}
