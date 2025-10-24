//
//  APIClient.swift
//  Wara
//
//  Created by Meow on 21/10/25.
//

import Foundation
import Alamofire

class HttpClient {
    static let shared = HttpClient()
    private init() {}

    func request<P: Encodable, T: Decodable>(
            url: String,
            method: HTTPMethod = .get,
            parameters: P? = nil,
            completion: @escaping (Result<T, NetworkError>) -> Void
        ) {
            
            var alamofireParameters: Parameters? = nil
            
           
            if let params = parameters {
                do {
                    let data = try JSONEncoder().encode(params)
                    alamofireParameters = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Parameters
                } catch {
                    
                    completion(.failure(.decodingError(error)))
                    return
                }
            }
            
            AF.request(url,
                       method: method,
                       parameters: alamofireParameters,
                       encoding: JSONEncoding.default)
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let value):
                        completion(.success(value))
                    case .failure(let afError):
                        if let decodingError = afError.underlyingError as? DecodingError {
                            completion(.failure(.decodingError(decodingError)))
                        } else {
                            completion(.failure(.afError(afError)))
                        }
                    }
                }
        }
}
