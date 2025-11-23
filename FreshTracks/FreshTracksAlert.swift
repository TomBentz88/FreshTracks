//
//  FreshTracksAlert.swift
//  FreshTracks
//
//  Created by Tom on 06/11/2025.
//

import Foundation

struct FreshTracksAlert: Identifiable {
    enum AlertType {
        case recreateMissingPlaylist
        case error
    }
    var id = UUID()
    var type: AlertType
    var message: String
}
