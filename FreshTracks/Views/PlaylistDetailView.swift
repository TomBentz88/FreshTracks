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
                HStack {
                    Spacer()
                    goToAppleMusic
                    Spacer()
                }.listRowSeparator(.hidden)
                ForEach(playlist.tracks ?? []) { track in
                    TrackRow(track: track)
                        .listRowInsets(EdgeInsets(top: 4, leading: 10, bottom: 4, trailing: 10))
                }
            } header: {

            }
            .navigationTitle(playlist.name)
        }
        .listStyle(.inset)
    }

    private var goToAppleMusic: some View {
        Button {

        } label: {
            Label {
                Text("Ouvrir dans Apple Music")
            } icon: {
                Image("apple_music_icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20)
            }

                .labelReservedIconWidth(20)
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
                    .font(.subheadline)
                Text(track.artistName)
                    .lineLimit(1)
                    .font(.footnote)
                    .foregroundStyle(Color(.secondaryLabel))
            }
        }
    }
}
