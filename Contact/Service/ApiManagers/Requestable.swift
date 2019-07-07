//
//  Requestable.swift
//  Contact
//
//  Created by Amit Singh on 05/07/19.
//  Copyright © 2019 Amit Singh. All rights reserved.
//

import UIKit

typealias Handler = (Result<Data>) -> Void
typealias DefaultCallBack = (DefaultResult<Data>) -> Void
typealias CompletionHandler = (ContactResult<[Contacts]>) -> Void
typealias ContactDetailCallBack = (ContactResult<ConactInfo>) -> Void

enum NetworkError: Error {
    case nullData
}

public enum Method {
    case get
    case put
    case post
}

enum NetworkingError: String, LocalizedError {
    case jsonError = "JSON error"
    case other
    var localizedDescription: String { return NSLocalizedString(self.rawValue, comment: "") }
}

extension Method {
    public init(_ rawValue: String) {
        let method = rawValue.uppercased()
        switch method {
        case "POST":
            self = .post
        case "PUT":
            self = .put
        default:
            self = .get
        }
    }
}

extension Method: CustomStringConvertible {
    public var description: String {
        switch self {
        case .get:               return "GET"
        case .post:              return "POST"
        case .put:               return "PUT"
        }
    }
}

protocol Requestable {}

extension Requestable {
    
     func request(method: Method, url: String, params: [String: Any]? = nil, callback: @escaping Handler) {
        
        guard let url = URL(string: url) else {
            return
        }
        
         var request = URLRequest(url: url)
        
         if let params = params {
          request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
         request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
            request.setValue(contentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
            
         }
        request.httpMethod = method.description
        
       let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
        
            DispatchQueue.main.async {
                
                if let error = error {
                    
                    print(error.localizedDescription)
                    
                } else if let httpResponse = response as? HTTPURLResponse {
                    
                    if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                        callback(.success(data!))
                    } else {
                        
                        callback(.failure(httpResponse.statusCode))
                    }
                }
            }
        })
        task.resume()
    }
}

