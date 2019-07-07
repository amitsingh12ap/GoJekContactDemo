//
//  Domain.swift
//  Contact
//
//  Created by Amit Singh on 05/07/19.
//  Copyright © 2019 Amit Singh. All rights reserved.
//

import Foundation

// MARK:- Create Base URLs
let commonContactString = "/contacts/"

// base url
struct Domain {
    static let dev = "https://gojek-contacts-app.herokuapp.com"
    static let assetUrl = "/images/"
}
// Header's key
enum HTTPHeaderField: String {
    case contentType  = "Content-Type"
}
// Header's Value
enum contentType: String {
    case json = "application/json"
}

// get all combined urls here
extension Domain {
    static func baseUrl()-> String {
        return dev
    }
    static func baseUrlWithContactsKey()-> String {
        return "\(dev)\(commonContactString)"
    }
    
    static func profileUrl()-> String {
        return assetUrl
    }
}
