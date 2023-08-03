//
//  Logger+Custom.swift
//  WeMeet
//
//  Created by Ajith Renjala on 02/08/23.
//

import Foundation
import OSLog

typealias Log = Logger

extension Logger {
    /// Using your bundle identifier is a great way to ensure a unique identifier.
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let userActivity = Logger(subsystem: subsystem, category: "userActivity")

    static let dbActivity = Logger(subsystem: subsystem, category: "databaseActivity")

    static let networkActivity = Logger(subsystem: subsystem, category: "networkActivity")
}
