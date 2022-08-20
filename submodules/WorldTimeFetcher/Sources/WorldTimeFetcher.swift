import Foundation
import SwiftSignalKit

public enum WorldTimeFetcherError: Error {
    case invalidServiceUrl
    case networkError
    case decodeError
    case generic
}

public protocol WorldTimeFetcherProtocol {
    func getCurrentTime() -> Signal<Int32, WorldTimeFetcherError>
}

public final class WorldTimeFetcher: WorldTimeFetcherProtocol {
    private enum Constants {
        static let WorldTimeServiceUrl = "http://worldtimeapi.org/api/timezone/Europe/Moscow"
    }
    
    public init() {}
    
    public func getCurrentTime() -> Signal<Int32, WorldTimeFetcherError> {
        return Signal { subscriber in
            guard let url = URL(string: Constants.WorldTimeServiceUrl) else {
                subscriber.putError(.invalidServiceUrl)
                return ActionDisposable {}
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: { data, response, error in
                if let _ = error {
                    subscriber.putError(.networkError)
                } else if let data = data {
                    let result = try? JSONDecoder().decode(WorldTimeResult.self, from: data)
                    if let timestamp = result?.timestamp {
                        subscriber.putNext(timestamp)
                        subscriber.putCompletion()
                    } else {
                        subscriber.putError(.decodeError)
                    }
                } else {
                    subscriber.putError(.generic)
                }
            })
            task.resume()
            
            return ActionDisposable {
                task.cancel()
            }
        }
    }
}

private struct WorldTimeResult: Codable {
    public let timestamp: Int32
    
    public enum CodingKeys: String, CodingKey {
        case timestamp = "unixtime"
    }
}
