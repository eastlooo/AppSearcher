//
//  DefaultProvider.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/12.
//

import Foundation

final class DefaultProvider {
    private let session: URLSessionable
    
    init(session: URLSessionable = URLSession.shared) {
        self.session = session
    }
    
    private func checkError(with data: Data?,
                            _ response: URLResponse?,
                            _ error: Error?,
                            completion: @escaping(Result<Data, Error>) -> ()) {
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let response = response as? HTTPURLResponse else {
            completion(.failure(NetworkError.unknownError))
            return
        }
        
        guard (200...299).contains(response.statusCode) else {
            completion(.failure(NetworkError.invalidHttpStatusCode(response.statusCode)))
            return
        }
        
        guard let data = data else {
            completion(.failure(NetworkError.emptyData))
            return
        }
        
        completion(.success(data))
    }
    
    private func decode<T: Decodable>(data: Data) -> Result<T, Error> {
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return .success(decoded)
        } catch {
            return .failure(NetworkError.emptyData)
        }
    }
}

extension DefaultProvider: Provider {
    func request<R: Decodable,
                 E: RequestResponsable>(with endpoint: E,
                                        completion: @escaping(Result<R, Error>) -> Void) where E.Response == R {
            do {
                let urlRequest = try endpoint.getURLRequest()
                
                session.dataTask(with: urlRequest) { [weak self] data, response, error in
                    self?.checkError(with: data, response, error) { result in
                        guard let self = self else { return }
                        
                        switch result {
                        case .success(let data):
                            completion(self.decode(data: data))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }.resume()
                
            } catch {
                completion(.failure(NetworkError.urlRequest(error)))
            }
    }
    
    func request<E: RequestResponsable>(_ endpoint: E,
                                        completion: @escaping(Result<Data, Error>) -> Void) {
            do {
                let urlRequest = try endpoint.getURLRequest()
                
                session.dataTask(with: urlRequest) { [weak self] data, response, error in
                    self?.checkError(with: data, response, error) { result in
                        
                        switch result {
                        case .success(let data):
                            completion(.success(data))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }.resume()
                
            } catch {
                completion(.failure(NetworkError.urlRequest(error)))
            }
    }
    
    func request(_ url: URL,
                 completion: @escaping (Result<Data, Error>) -> Void) {
        session.dataTask(with: url) { [weak self] data, response, error in
            self?.checkError(with: data, response, error) { result in
                completion(result)
            }
        }.resume()
    }
}
