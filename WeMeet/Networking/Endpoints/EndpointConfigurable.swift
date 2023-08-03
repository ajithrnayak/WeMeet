//
//  EndpointConfigurable.swift
//  WeMeet
//
//  Created by Ajith Renjala on 03/08/23.
//

import Foundation

public protocol EndpointConfigurable {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
    var request: URLRequest { get }
}

public enum HTTPMethod: String, RawRepresentable,
                        Equatable, Hashable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}
