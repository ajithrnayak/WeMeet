//
//  RoomsEndpoint.swift
//  WeMeet
//
//  Created by Ajith Renjala on 03/08/23.
//

import Foundation

public enum RoomsEndpoint: EndpointConfigurable {
    case meetingRoomsList
    case bookRoom(roomID: String)
    
    public var baseURL: URL {
        return AppEnvironment.current.baseURL
    }

    public var path: String {
        switch self {
        case .meetingRoomsList:
            return "/rooms.json"
        case .bookRoom:
            return "/bookRoom.json"
        }
    }

    public var method: HTTPMethod {
        return .get
    }

    public var headers: [String: String]? {
        return ["Content-Type": "application/ json"]
    }

    public var body: Data? {
        return nil
    }

    public var request: URLRequest {
        let fullURL = baseURL.appending(path: path)
        var request = URLRequest(url: fullURL)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        // request.timeoutInterval = 180
        return request
    }

}
