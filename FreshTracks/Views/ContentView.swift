//
//  ContentView.swift
//  FreshTracks
//
//  Created by Tom on 14/02/2025.
//

import SwiftUI
import AppIntents
import _AppIntents_UIKit

struct ContentView: View {

    @State private var showCreatePlaylistView: Bool = false
    @FocusState private var isFocused: Bool
    @State private var newPlaylistTrackNumberString: String = ""
    @State private var errorMessage: String?

    @ObservedObject private var viewModel: FreshTracksViewModel

    let columns = [GridItem(.flexible()), GridItem(.flexible())] // Grille 2x2

    init(viewModel: FreshTracksViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    LazyVGrid(columns: columns, spacing: 10) {

                        ForEach(viewModel.store.playlists) { playlist in
                            playlistButtonWithAction(trackNumber: playlist.tracksNumber, color: .orange)
                        }
                    }
                    .padding()

                    Spacer()
                }
                .navigationTitle("FreshTracks")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button("New", systemImage: "plus") {
                            showCreatePlaylistView = true
                            isFocused = true
                        }
                    }
                }

                // Popup Overlay
                if showCreatePlaylistView {
                    // Fond semi-transparent
                    Color.black.opacity(0.4)
                        .blur(radius: 0.5)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                showCreatePlaylistView = false
                            }
                        }

                    // Contenu popup
                    VStack(spacing: 20) {
                        Text("Entrez quelque chose")
                            .font(.headline)
                            .padding(.top)

                        TextField("Votre texte ici", text: $newPlaylistTrackNumberString)
                            .font(Font.largeTitle)
                            .multilineTextAlignment(.center)
                            .keyboardType(.numberPad)
                            .padding()
                            .focused($isFocused)

                        Button("Créer") {
                            if let number = Int(newPlaylistTrackNumberString), number > 0 {
                                let result = viewModel.addPlaylist(tracksNumber: number)
                                if case .failure(let error) = result {
                                    errorMessage = error.localizedDescription
                                }
                            }

                            print("Texte saisi : \(newPlaylistTrackNumberString)")

                            showCreatePlaylistView = false
                        }
                        .alert("Erreur", isPresented: .constant(errorMessage != nil)) {
                            Button("OK") { errorMessage = nil }
                        } message: {
                            Text(errorMessage ?? "")
                        }
                        .frame(width: 100, height: 60)
                        .glassEffect()
                        .padding()

                    }
                    .transition(.scale.combined(with: .opacity)) // animation apparition
                    .glassEffect()
                    .padding()

                }
            }
            .alert(item: $viewModel.alert) { alert in
                switch alert.type {
                case .recreateMissingPlaylist:
                    return Alert(
                        title: Text("Something went wrong"),
                        message: Text(alert.message),
                        primaryButton: .default(Text("Yes"), action: {
                            Task {
                                viewModel.recreateMissingPlaylists()
                            }
                        }),
                        secondaryButton: .default(Text("No"), action: {
                            Task {
                                viewModel.eraseMissingPlaylists()
                            }
                    }))
                }
            }
        }
    }

    private func playlistButtonWithAction(trackNumber: Int, color: Color) -> PlaylistButton {
        return PlaylistButton(trackNumber: trackNumber, color: color) {}
    }
}

#Preview {
    ContentView(viewModel: FreshTracksViewModel())
}
