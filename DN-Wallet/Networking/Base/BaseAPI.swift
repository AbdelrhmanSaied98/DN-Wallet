//
//  BaseAPI.swift
//  NetworkLayerWithGenerics-IOS13
//
//  Created by Mac OS on 7/2/20.
//  Copyright © 2020 Ahmed Eid. All rights reserved.
//

import Foundation
import KeychainSwift

struct SuccessResponse: Decodable {
    var success: String
}

class BaseAPI<T: TargetType> {
    private let keychain = KeychainSwift(keyPrefix: keys.keyPrefix)
    
    
    func APIRequest<M: Decodable>(target: T ,responseClass: M.Type, completion: @escaping (Result<M, NSError>) -> ()) {
        
        // Construct URL
        guard let url = URL(string: target.baseURL + target.path) else {
            print("Debug::Error-> Invalid URL, con not construct url from base and path.")
            return
        }
        
        // Build Request
        var request = URLRequest(url: url)
        request.httpMethod = target.method.rawValue
        request.allHTTPHeaderFields = target.header
        
        // Check if request need a user token
        if target.tokenRequired {
            request.setValue(keychain.get(keys.token), forHTTPHeaderField: "x-auth-token")
        }
        
        // Check if this request has a body
        let params = buildParameters(task: target.task)
        
        if let body = params {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                print("No Body Coming")
            }
            
        }
        // Start a data task
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Check if there is a internet error
            if let _ = error {
                print("Debug::Error-> server return error, request can not compelete")
                let error = NSError(domain: target.baseURL, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.unableToComplete])
                completion(.failure(error))
                return
            }
            
            // Check if there is a response
            guard let response = response as? HTTPURLResponse else {
                print("Debug::Warning-> No Server Response")
                let error = NSError(domain: target.baseURL, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.invalidResponse])
                completion(.failure(error))
                return
            }
            
            let invalidDataError = NSError(domain: target.baseURL, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.invalidData])
            
            // Check the response status Code
            if response.statusCode == 200 {
                
                // Check if the server return the data correctly
                guard let safeData = data else {
                    print("Debug::Error-> no data comming")
                    completion(.failure(invalidDataError))
                    return
                }
                // Decode the json data into out responseClass
                print("SafeData: \(String(data: safeData, encoding: .utf8))")
                guard let result = try? JSONDecoder().decode(M.self, from: safeData) else {
                    print("Debug::Error-> Can not parse give date to your response class")
                    completion(.failure(invalidDataError))
                    return
                }
                // if the two previouse steps done correctly the the request is success.
                print("Debug::Success-> Parse Data Successfully!")
                completion(.success(result))
                
            }
            // Try to read the error which returned by the server if the status code not equal 200
            else {
                // server return an error
                guard let safeData = data else {
                    print("Debug::Error-> status code not 200 and also no data comming")
                    completion(.failure(invalidDataError))
                    return
                }
                // Decode the error json into our Error responseClass
                guard let err = try? JSONDecoder().decode(ErrorResponse.self, from: safeData) else {
                    completion(.failure(invalidDataError))
                    return
                }
                let error = NSError(domain: target.baseURL, code: 0, userInfo: [NSLocalizedDescriptionKey: err.error])
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    // Decide if the request has a body or not 
    private func buildParameters(task: Task) -> [String: Any]? {
        switch task {
            case .requestPlain:
                return nil
            case .requestParameters(let parameters):
                return parameters
        }
    }
}
