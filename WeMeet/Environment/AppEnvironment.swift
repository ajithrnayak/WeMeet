//
//  AppEnvironment.swift
//  WeMeet
//
//  Created by Ajith Renjala on 02/08/23.
//

import Foundation

/// Note: Ensure that the `rawValue` matches name of Xcode Configurations
enum ConfigurationType: String {
    case debugDevelopment = "Debug Development"
    case releaseDevelopment = "Release Development"
    case debugStaging = "Debug Staging"
    case releaseStaging = "Release Staging"
    case debugProduction = "Debug Production"
    case releaseProduction = "Release Production"
}

public enum AppEnvironment: String {
    case development = "Development"
    case staging = "Staging"
    case production = "Production"

    init(configType: ConfigurationType) {
        switch configType {
        case .debugDevelopment, .releaseDevelopment:
            self = .development
        case .debugStaging, .releaseStaging:
            self = .staging
        case .debugProduction, .releaseProduction:
            self = .production
        }
    }

    var configuration: String {
        return self.rawValue
    }

    static var current: AppEnvironment {
        guard let currentConfig = AppEnvironment.infoDictionary["Configuration"] as? String,
              let configType = ConfigurationType(rawValue: currentConfig) else {
            fatalError("Environment configurations have been modified!")
        }
        return AppEnvironment(configType: configType)
    }

    // MARK: - Helpers

    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()
}

// MARK: - Remote URLs

extension AppEnvironment {

    var baseURL: URL {
        switch self {
        case .development:
            fallthrough
        case .staging:
            fallthrough
        case .production:
            return URL(string: "https://wetransfer.github.io")!
        }
    }
}
