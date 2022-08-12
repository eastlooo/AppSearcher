//
//  DefaultProvider.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/12.
//

import Foundation
import Combine

final class DefaultProvider {
    private let session: URLSessionable
    
    init(session: URLSessionable = URLSession.shared) {
        self.session = session
    }
}

extension DefaultProvider: Provider {
    func request<R: Decodable,
                 E: RequestResponsable>(with endpoint: E) -> AnyPublisher<R, Error> where E.Response == R {
            do {
                let urlRequest = try endpoint.getURLRequest()
                
                return  session.dataTaskPublisher(for: urlRequest)
                    .tryMap(checkOutput)
                    .decode(type: R.self, decoder: JSONDecoder())
                    .eraseToAnyPublisher()
            } catch {
                return Fail<R, Error>(error: NetworkError.urlRequest(error))
                    .eraseToAnyPublisher()
            }
    }
    
    func request(_ url: URL) -> AnyPublisher<Data, Error> {
        return session.dataTaskPublisher(for: url)
            .tryMap(checkOutput)
            .eraseToAnyPublisher()
    }
}

private func checkOutput(_ output: URLSession.DataTaskPublisher.Output) throws -> Data {
    
    guard let response = output.response as? HTTPURLResponse else {
        throw NetworkError.unknownError
    }
    
    guard (200...299).contains(response.statusCode) else {
        throw NetworkError.invalidHttpStatusCode(response.statusCode)
    }
    
    return output.data
}
