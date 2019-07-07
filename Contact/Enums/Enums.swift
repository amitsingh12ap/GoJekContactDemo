//
//  Enums.swift
//  Contact
//
//  Created by Amit Singh on 05/07/19.
//  Copyright © 2019 Amit Singh. All rights reserved.
//

import Foundation

enum Failure: Error {
    case apiFailure
    case decodeFailure

    var message: String {
        switch self {
            case .apiFailure: return "Please review webservice."
            case .decodeFailure: return "Something went wrong with api response. Failed to decode"
        }
    }
}

enum ContactResult<Value: Decodable> {
    case success(Value)
    case failure(Failure)
}

enum Result<Value: Decodable> {
    case success(Value)
    case failure(Int)
}

enum DefaultResult<Value: Decodable> {
    case success(Value)
    case failure(Failure)
}
