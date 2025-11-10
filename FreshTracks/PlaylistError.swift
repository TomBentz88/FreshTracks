//
//  PlaylistError.swift
//  FreshTracks
//
//  Created by Tom on 06/11/2025.
//

import Foundation

enum PlaylistError: Error, LocalizedError {
    case alreadyExists
    case noTracks
    case notAuthorized
    case swiftDataError(Error)

    var errorDescription: String? {
        switch self {
        case .alreadyExists:
            return "Cette playlist existe déjà."
        case .noTracks:
            return "Cette playlist ne contient aucun morceau."
        case .notAuthorized:
            return "Vous n'êtes pas autorisé à gérer cette playlist."
        case let .swiftDataError(error):
            return "Erreur SwiftData : \(error.localizedDescription)"
        }
    }
}
