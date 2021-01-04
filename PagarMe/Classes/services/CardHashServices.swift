//
//  CardHashServices.swift
//  Alamofire
//
//  Created by Regis Araujo Melo on 01/01/21.
//

import Foundation

class CardHashServices {
    
    public static let shared = CardHashServices()
    
    private init() {}
    private let urlSession = URLSession.shared
    
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }()
    
    public enum APIServiceError: Error {
        case apiError
        case invalidEndpoint
        case invalidResponse
        case noData
        case decodeError
    }
    
    enum Endpoint: String, CaseIterable {
        case card_hash_key = "card_hash_key"
    }
    
    //    GET /transactions/
    private func getUrlFromCardHash() -> String {
        return "\(API_ENDPOINT)/transactions"
    }
    
    private func fetchResources<T: Decodable>(url: URL, completion: @escaping (Result<T, APIServiceError>) -> Void) {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        let pagarMe = PagarMe.sharedInstance()
        guard let key = pagarMe?.encryptionKey else {
            return
        }
        
        let queryItems = [URLQueryItem(name: "api_key", value: key)]
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        urlSession.dataTask(with: url) { (result) in
            switch result {
            case .success(let (response, data)):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                    completion(.failure(.invalidResponse))
                    return
                }
                do {
                    let values = try self.jsonDecoder.decode(T.self, from: data)
                    completion(.success(values))
                } catch {
                    completion(.failure(.decodeError))
                }
            case .failure(let error):
                completion(.failure(.apiError))
            }
        }.resume()
    }
    
    public func fetchCardHash(from endpoint: Endpoint, result: @escaping (Result<CardHashResponse, APIServiceError>) -> Void) {
        let url = URL(string: getUrlFromCardHash())?.appendingPathComponent(endpoint.rawValue)
        fetchResources(url: url!, completion: result)
    }
}
