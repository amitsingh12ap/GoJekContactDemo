//
//  ContactServiceProtocol.swift
//  Contact
//
//  Created by Amit Singh on 05/07/19.
//  Copyright © 2019 Amit Singh. All rights reserved.
//

import Foundation

protocol ContactListProtocol: class {
    func contactListdidFinishedByGettingContactData()
    func failedToGetContacts(_ error: Failure)
}
protocol ContactDetailProtocol: class {
    func didFinishByGettingContactInfo()
    func failedToGetContactInfo(_ error: Failure)
    func contactUpdated(_ status: Bool)
}
protocol AddContactProtocol: class {
    func contactCreated(status: Bool)
}
