//
//  NetworkClient.swift
//  WeMeet
//
//  Created by Ajith Renjala on 03/08/23.
//

import Foundation

public enum NetworkError: Error {
    case decodeFailed(Error)
}

public final class NetworkClient<T: EndpointConfigurable> {

    public let session: URLSession

    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    public func performDataRequest<R: Decodable>(
        _ endpoint: T,
        decoder: JSONDecoder = JSONDecoder()
    ) async throws -> R {
        let request = endpoint.request
        let (data, urlResponse) = try await session.data(for: request)

        if let statusCode = (urlResponse as? HTTPURLResponse)?.statusCode {
            Log.networkActivity.info("Responded with Status Code:\(statusCode)")
        }

        do {
            return try decoder.decode(R.self, from: data)
        } catch {
            throw NetworkError.decodeFailed(error)
        }
    }

}
