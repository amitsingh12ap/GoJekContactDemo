//
//  CommonProtocols.swift
//  Contact
//
//  Created by Amit Singh on 07/07/19.
//  Copyright © 2019 Amit Singh. All rights reserved.
//

import Foundation

protocol UpdateContact: class {
    func markFavouriteToContact()
    func updateContactInfo()
    func smsClicked()
    func callClicked()
    func emailClicked()
}
