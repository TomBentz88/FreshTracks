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

    @State private var navigationPath = NavigationPath()
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
        NavigationStack {
            ZStack {
                VStack {
                    if playlists.count == 0 {
                        onboardingStateView
                            .padding()
                        Spacer()
                    } else {
                        playlistList
                            .ignoresSafeArea(.keyboard)
                    }
                }

                playlistCreation
            }.navigationDestination(item: $viewModel.selectedPlaylist) { playlist in
                PlaylistDetailView(playlist: playlist)
            }
            .navigationTitle("Fresh Tracks")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Refresh", systemImage: "arrow.trianglehead.2.clockwise") {
                        Task {
                            try? await viewModel.refreshAllPlaylists()
                        }
                    }
                    .symbolEffect(.rotate, options: .repeat(.continuous), value: viewModel.isRefreshing)
                    .disabled(viewModel.isRefreshing)
                }
                if !showCreatePlaylistView {
                    ToolbarSpacer(.flexible, placement: .bottomBar)
                    ToolbarItem(placement: .bottomBar) {
                        Button("Add", systemImage: "plus") {
                            showCreatePlaylist()
                        }
                        .buttonStyle(.glassProminent)
                        .tint(.freshTracksBlue)
                    }
                }
            }
        }
        .alert(item: $viewModel.alert) { alert in
            switch alert.type {
            case .recreateMissingPlaylist:
                alertFor(alert)
            case .error:
                alertFor(alert)
            }
        }
    }

    private var emptyStateView: some View {
        VStack {
            Image(systemName: "music.note.list")
            Text("Bienvenu sur Fresh Tracks")
            Text("Créez votre première playlist à partir de vos derniers morceaux")
            createPlaylistButton
        }
    }

    private var onboardingStateView: some View {
        VStack {
            Image(systemName: "music.note.list")
                .font(.title2)
                .padding()
            Text("Bienvenue sur Fresh Tracks")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            Text("Générez votre première playlist à partir de vos derniers morceaux")
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.top)
                .padding(.horizontal)
            createPlaylistButton
                .padding()
        }.glassEffect(.clear.tint(.gray.opacity(0.15)),in: RoundedRectangle(cornerRadius: 20))
    }

    private func showCreatePlaylist() {
        showCreatePlaylistView = true
        textFieldFocused = true
    }

    private var createPlaylistButton: some View {
        Button {
            showCreatePlaylistView = true
            textFieldFocused = true
        } label: {
            Text("Créer une playlist")
                .font(.title3)
                .tint(.white)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 14)
                        .foregroundStyle(.linearGradient(colors: [.freshTracksGreen, .freshTracksBlue], startPoint: .topLeading, endPoint: .bottomTrailing))
                }
        }
    }

    private var playlistGrid: some View {
        ScrollView {
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
            .padding(.horizontal)
            
        }.background {
            backgroundMosaic
        }.edgesIgnoringSafeArea(.bottom)
    }

    private var playlistList: some View {
        List {
            Section {
                shortcutView
                    .listRowSeparator(.hidden)

                ForEach(playlists) { playlist in
                    PlaylistRow(playlist: playlist) {
                        viewModel.tapOnPlaylist(playlist)
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            viewModel.deletePlaylist(playlist)
                        } label: {
                            Label("Supprimer", systemImage: "trash")
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
            } header: {
//                createPlaylistButton
            }
            .listRowInsets(.init(top: 10, leading: 14, bottom: 10, trailing: 14))
        }
        .listStyle(.plain)
        .background {
            backgroundMosaic
        }
        .scrollContentBackground(.hidden)
        .edgesIgnoringSafeArea(.bottom)
    }

    private var shortcutView: some View {
        VStack {
            HStack {
                Label("Suggestion", systemImage: "lightbulb.min.fill")
                    .tint(.primary)
                    .foregroundStyle(.primary)
                    .padding()
            }
            Text("Utilisez l'app Raccourcis pour automatiser le rafraichissement des playslits.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
            ShortcutsLink()
                .shortcutsLinkStyle(.automaticOutline)
                .padding()
        }.glassEffect(.clear.tint(.gray.opacity(0.15)),in: RoundedRectangle(cornerRadius: 20))
    }

    private var backgroundMosaic: some View {
        VStack {
            Spacer()

            Image("mosaic_white")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 200)
                .clipped()
                .mask(
                    LinearGradient(gradient: Gradient(colors: [Color.black, Color.black.opacity(0)]), startPoint: .bottom, endPoint: .top)
                )
        }
    }

    private var playlistCreation: some View {
        ZStack {
            // Popup Overlay
            if showCreatePlaylistView {
                // Fond semi-transparent avec fade
                Color.black.opacity(0.6)
                    .blur(radius: 0.5)
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
                    .onTapGesture {
                        hideCreatePlaylistView()
                    }

                // Contenu popup
                VStack(spacing: 20) {
                    Text("Combien de morceaux ?")
                        .font(.headline)
                        .fontWeight(.medium)
//                        .padding()
                        .padding([.top, .horizontal], 20)


                    TextField("", text: $newPlaylistTrackNumberString)
                        .font(Font.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .tint(.primary)
                        .keyboardType(.numberPad)
                        .focused($textFieldFocused)

                    Button {

                        guard let number = Int(newPlaylistTrackNumberString), number > 0 else {
                            return
                        }
                        hideCreatePlaylistView()

                        Task.detached(priority: .background) {
                            do {
                                try await viewModel.addPlaylist(tracksNumber: number)
                            } catch {
                                await MainActor.run {
                                    errorMessage = error.localizedDescription
                                }
                            }
                        }
                    } label: {
                        Text("Valider")
                            .font(.headline)
                            .tint(.white)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .alert("Erreur", isPresented: .constant(errorMessage != nil)) {
                        Button("OK") { errorMessage = nil }
                    } message: {
                        Text(errorMessage ?? "")
                    }
                    .glassEffect(.clear.tint(.freshTracksGreen))
                    .padding([.bottom, .horizontal], 16)
                }
                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 42))
                .frame(width: 300)
                .transition(
                    .asymmetric(
                        insertion: .scale(scale: 1.05).combined(with: .opacity),
                        removal: .scale(scale: 0.9).combined(with: .opacity)
                    )
                )
                .zIndex(1)
            }
        }
        // Animation globale pour apparition/disparition
        .animation(
            .spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.2),
            value: showCreatePlaylistView
        )
    }

    private func alertFor(_ alert: FreshTracksAlert) -> Alert {
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

    private func hideCreatePlaylistView() {
        withAnimation {
            showCreatePlaylistView = false
            textFieldFocused = false
        }
        newPlaylistTrackNumberString = ""
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
