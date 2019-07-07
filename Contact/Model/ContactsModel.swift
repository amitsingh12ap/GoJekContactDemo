//
//  ContactsModel.swift
//  Contact
//
//  Created by Amit Singh on 05/07/19.
//  Copyright © 2019 Amit Singh. All rights reserved.
//

import Foundation

struct Contacts: Codable {
    var id: Int
    var firstName: String
    var lastName: String
    var profilePic: String
    var favorite: Bool
    var url: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case profilePic = "profile_pic"
        case favorite = "favorite"
        case url = "url"
    }
}
