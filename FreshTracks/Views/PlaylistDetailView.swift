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
            Section {
                ForEach(playlist.tracks ?? []) { track in
                    TrackRow(track: track)
                }
            } header: {
                goToAppleMusic
            }
            .navigationTitle(playlist.name)
        }
    }

    private var goToAppleMusic: some View {
        Button {

        } label: {
            Label("Ouvrir dans Apple Music", systemImage: "music.note")
                .tint(.white)
                .fontWeight(.semibold)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 14)
                        .foregroundStyle(.linearGradient(colors: [.appleMusic1, .appleMusic2], startPoint: .bottom, endPoint: .top))
                }
        }
    }
}

struct TrackRow: View {
    let track: Track

    var body: some View {
        HStack {
            if let artwork = track.artwork {
                ArtworkImage(artwork, width: 50)
                    .cornerRadius(4)
            }
            VStack(alignment: .leading) {
                Text(track.title)
                    .lineLimit(1)
                    .font(.caption)
                Spacer()
                Text(track.artistName)
                    .font(.caption2)
                    .foregroundStyle(Color(.secondaryLabel))
            }
        }
    }
}
