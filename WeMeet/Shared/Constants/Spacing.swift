//
//  Spacing.swift
//  WeMeet
//
//  Created by Ajith Renjala on 02/08/23.
//

import Foundation

public enum Spacing {
    case half, full, double, standard,
         multipliedBy(CGFloat), custom(CGFloat)

    var base: CGFloat {
        return 8.0
    }

    public var value: CGFloat {
        switch self {
        case .half: return base / 2
        case .full: return base
        case .double: return base * 2
        case .standard: return base * 2.5
        case .multipliedBy(let multiplier): return base * multiplier
        case .custom(let value): return value
        }
    }
}
