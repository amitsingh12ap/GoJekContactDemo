//
//  EndPoint.swift
//  Contact
//
//  Created by Amit Singh on 05/07/19.
//  Copyright © 2019 Amit Singh. All rights reserved.
//

import Foundation

let kAllContacts = "contacts"
let kDefaultApiExtention = ".json"

enum EndPoint {
    case getAllContacts
    case getContactById(Id: Int)
    case getContactDetailWithContactId(contactId: Int)
    case deleteContactWithContactId(contactId: Int)
    case updateContactDetailWithContactId(contactId: Int)
    
    var path: String {
        switch self {
            
        case .getAllContacts:
            return "\(Domain.baseUrl())/\(kAllContacts)\(kDefaultApiExtention)"
            
        case .getContactById(let contactId),.getContactDetailWithContactId(let contactId),.updateContactDetailWithContactId(let contactId),.deleteContactWithContactId(let contactId):
           
            return "\(Domain.baseUrlWithContactsKey())\(contactId)\(kDefaultApiExtention)"
        }
    }
}
