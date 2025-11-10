//
//  HomeView.swift
//  FreshTracks
//
//  Created by Tom on 10/11/2025.
//

import SwiftUI

struct HomeView: View {

    @Environment(\.modelContext) private var context

    var body: some View {
        playlistView
    }

    @ViewBuilder
    private var playlistView: some View {
        let viewModel = FreshTracksViewModel(context: context)
        FreshTracksView(viewModel: viewModel)
    }
}
