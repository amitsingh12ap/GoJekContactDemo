//
//  ContactDetailViewModel.swift
//  Contact
//
//  Created by Amit Singh on 07/07/19.
//  Copyright © 2019 Amit Singh. All rights reserved.
//

import UIKit

class ContactDetailViewModel: NSObject {

    weak var delelgate: ContactDetailProtocol?
    var contactDetail: ConactInfo?

    func getContactDetail(forContactId  contactId: Int) {        
        let webRequest = WebRequest()
        webRequest.fetchContactDetailFromServer(contactId: contactId) { [weak self](result) in
            guard let self = self else { return }
            switch result {
                case .success(let contactInfo):
                    self.contactDetail = contactInfo
                    self.delelgate?.didFinishByGettingContactInfo()
                case .failure(let error):
                    self.delelgate?.failedToGetContactInfo(error)
            }
        }
    }
    
    func getProfileUrl()-> String{
        return "\(Domain.baseUrl())\(contactDetail?.profileImageUrl ?? "")"
    }
    
    func getFullName()-> String {
        return "\(contactDetail?.firstName ?? "") \(contactDetail?.lastName ?? "")"
    }
    
    func getMobileNumber()-> String {
        return contactDetail?.phoneNumber ?? ""
    }
    
    func getEmailId()-> String {
        return contactDetail?.email ?? ""
    }
    
    func markFavourite() {
        
        guard  var contactInfo = contactDetail else {return}
         let webRequest = WebRequest()
        contactInfo.isFavorite = !contactInfo.isFavorite
        webRequest.updateContactInfoToServer(body: contactInfo) {[weak self] (data) in
            switch data {
                case .success(_):
                    self?.delelgate?.contactUpdated(true)
                case .failure(_):
                    self?.delelgate?.contactUpdated(false)
            }
        }
    }
}
extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
