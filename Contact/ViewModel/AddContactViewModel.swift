//
//  AddContactViewModel.swift
//  Contact
//
//  Created by Amit Singh on 07/07/19.
//  Copyright © 2019 Amit Singh. All rights reserved.
//

import UIKit

class AddContactViewModel: NSObject {
    weak var delelgate: AddContactProtocol?
    
    func createContact(contactmodel: ConactInfo) {
        let webrequest = WebRequest()
        webrequest.createContactToServer(body: contactmodel) {[weak self] (result) in
            switch result {
            case .success(_):
                self?.delelgate?.contactCreated(status: true)
            case .failure(_):
                self?.delelgate?.contactCreated(status: false)
            }
        }
    }
}
