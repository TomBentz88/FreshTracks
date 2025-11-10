//
//  PlaylistTile.swift
//  FreshTracks
//
//  Created by Tom on 06/11/2025.
//

import SwiftUI

struct PlaylistTile: View {
    let playlist: FreshTracksPlaylist

    var action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            VStack() {
                ProgressView().opacity(playlist.refreshing ? 1 : 0)
                Spacer()
                Text("Last")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(alignment: .bottom) {
                    Text("\(playlist.tracksNumber)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text("tracks")
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.bottom, 5)


                }.frame(maxWidth: .infinity, alignment: .leading)

            }
            
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: 130)
//            .background(.linearGradient(colors: [.secondary, .secondary.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing))
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 20))
//            .cornerRadius(20)
            //                .shadow(radius: 5)
        }
    }
}

#Preview {
    let playlist = FreshTracksPlaylist(tracksNumber: 50)
    PlaylistTile(playlist: playlist) {}
}
