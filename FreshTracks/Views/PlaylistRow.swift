//
//  PlaylistRow.swift
//  FreshTracks
//
//  Created by Tom on 18/11/2025.
//

import SwiftUI

struct PlaylistRow: View {
    let playlist: FreshTracksPlaylist

    var action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            HStack() {
                Text("\(playlist.tracksNumber)")
                    .font(.system(size: 40))
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                VStack {
                    Text("Derniers morceaux")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top)

                    Spacer()

                    Text("Mis à jour il y a 7 jours")
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom)

                }


            }
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .glassEffect(.clear, in: RoundedRectangle(cornerRadius: 20))
        }
    }
}

#Preview {
    let playlist = FreshTracksPlaylist(tracksNumber: 50)
    PlaylistRow(playlist: playlist) {}
}
