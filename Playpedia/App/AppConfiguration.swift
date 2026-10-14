//
//  AppConfiguration.swift
//  Playpedia
//
//  Created by Ferdiansyah Annora on 12/10/26.
//

import Foundation

enum AppConfiguration {
    static var rawgAPIKey: String {
        let value = Bundle.main.object(forInfoDictionaryKey: "RAWGAPIKey") as? String ?? ""
        let key = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return key.hasPrefix("$(") ? "" : key
    }
}
