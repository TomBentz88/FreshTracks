//
//  FreshTracksView.swift
//  FreshTracks
//
//  Created by Tom on 14/02/2025.
//
import AppIntents
import _AppIntents_UIKit
import SwiftData
import SwiftUI

struct FreshTracksView: View {

    @Environment(\.modelContext) private var context
    @Query(sort: \FreshTracksPlaylist.tracksNumber, order: .forward) private var playlists: [FreshTracksPlaylist]

    @State private var showCreatePlaylistView: Bool = false
    @FocusState private var textFieldFocused: Bool
    @State private var newPlaylistTrackNumberString: String = ""
    @State private var errorMessage: String?

    @ObservedObject private var viewModel: FreshTracksViewModel

    let columns = [GridItem(.flexible()), GridItem(.flexible())] // Grille 2x2

    init(viewModel: FreshTracksViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            NavigationStack {
                GeometryReader { _ in // ugly hack to stop the view from moving on keyboard apparition (.ignoreSafeArea(.keyboard) not working)
                    VStack {
                        Button {
                            showCreatePlaylistView = true
                            textFieldFocused = true
                        } label: {
                            Text("Créer une playlist")
                                .font(.title2)
                                .tint(.white)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background {
                                    RoundedRectangle(cornerRadius: 14)
                                        .foregroundStyle(.linearGradient(colors: [.freshTracksGreen, .freshTracksBlue], startPoint: .topLeading, endPoint: .bottomTrailing))
                                }
                                .padding()
                        }

                        HStack {
                            Text("Vos playlists")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                        }.padding(.horizontal)

                        LazyVGrid(columns: columns, spacing: 10) {

                            ForEach(playlists) { playlist in
                                PlaylistTile(playlist: playlist) {
                                    viewModel.openAppleMusic(playlist: playlist)
                                }.contextMenu {
                                    Button(role: .destructive) {
                                        viewModel.deletePlaylist(playlist)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                        .padding()

                        Spacer()
                    }
                    .navigationTitle("FreshTracks")
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Button("Refresh", systemImage: "arrow.trianglehead.2.clockwise") {
                                Task {
                                    try? await viewModel.refreshAllPlaylists()
                                }
                            }
                        }
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
                            textFieldFocused = false
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
                        .focused($textFieldFocused)

                    Button("Créer") {
                        if let number = Int(newPlaylistTrackNumberString), number > 0 {
                            let result = viewModel.addPlaylist(tracksNumber: number)
                            if case .failure(let error) = result {
                                errorMessage = error.localizedDescription
                            }
                        }

                        print("Texte saisi : \(newPlaylistTrackNumberString)")

                        showCreatePlaylistView = false
                        textFieldFocused = false
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
                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 28))
                .frame(width: 300)

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

#Preview {
    let previewContainer = try! ModelContainer(
        for: FreshTracksPlaylist.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let context = previewContainer.mainContext
    let viewModel = FreshTracksViewModel(context: context)
    return FreshTracksView(viewModel: viewModel)
        .modelContainer(previewContainer)
}
