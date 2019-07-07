//
//  ContactInfoModel.swift
//  Contact
//
//  Created by Amit Singh on 07/07/19.
//  Copyright © 2019 Amit Singh. All rights reserved.
//

import Foundation

struct ConactInfo: Codable {
    var contactId: Int?
    var firstName: String?
    var lastName: String?
    var email: String?
    var phoneNumber: String?
    var profileImageUrl: String?
    var isFavorite: Bool
    var createdAt: String?
    var updatedAt: String?
    
    private enum CodingKeys: String, CodingKey {
        case contactId = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case email = "email"
        case profileImageUrl = "profile_pic"
        case isFavorite = "favorite"
        case createdAt = "created_at"
        case phoneNumber = "phone_number"
        case updatedAt = "updated_at"
    }
}
