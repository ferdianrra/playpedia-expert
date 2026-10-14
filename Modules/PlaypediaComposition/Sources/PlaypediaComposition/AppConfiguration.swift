//
//  AppConfiguration.swift
//  Playpedia
//
//  Created by Ferdiansyah Annora on 12/10/26.
//

import PlaypediaDomain
import PlaypediaData
import PlaypediaFavoritesState
import Foundation

public enum AppConfiguration {
    public static var rawgAPIKey: String {
        let value = Bundle.main.object(forInfoDictionaryKey: "RAWGAPIKey") as? String ?? ""
        let key = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return key.hasPrefix("$(") ? "" : key
    }
}
