//
//  PlaylistButton.swift
//  FreshTracks
//
//  Created by Tom on 06/11/2025.
//

import SwiftUI

struct PlaylistButton: View {
//    @Bindable var playlist: FreshTracksPlaylist
    
    let trackNumber: Int
    let color: Color
    var action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            VStack() {
                Spacer()
                Text("Last")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(alignment: .bottom) {
                    Text("\(trackNumber)")
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
            .background(.linearGradient(colors: [color, color.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(20)
            //                .shadow(radius: 5)
        }
    }
}
