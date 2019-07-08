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

    // MARK:- API Calls
    func getContactDetail(forContactId  contactId: Int) {        
        let webRequest = WebRequest()
        webRequest.fetchContactDetailFromServer(contactId: contactId) { [weak self](result) in
            switch result {
                case .success(let contactInfo):
                    self?.contactDetail = contactInfo
                    self?.delelgate?.didFinishByGettingContactInfo()
                case .failure(let error):
                    self?.delelgate?.failedToGetContactInfo(error)
            }
        }
    }
    
    
    func delegateContact() {
        let webRequest = WebRequest()
        guard  let contactId = contactDetail?.contactId else {return}
        webRequest.deleteContactFromServer(contactId: contactId) { [weak self] (result) in
            switch result {
                case .success(_):
                    self?.delelgate?.contactDeleted(true)
                case .failure(_): 
                    self?.delelgate?.contactDeleted(true)
            }
        }
    }
    
    func updateContactWithInfo(mobileNumber: String, emailID: String) {
        
        guard var contactInfo = contactDetail else {
            return
        }
        contactInfo.email = emailID
        contactInfo.phoneNumber = mobileNumber
        self.updateContactInfo(body: contactInfo)
        
    }
    func markFavourite() {
        
        guard  var contactInfo = contactDetail else {return}
        contactInfo.isFavorite = !contactInfo.isFavorite
        self.updateContactInfo(body: contactInfo)
    }
    
    func updateContactInfo(body: ConactInfo) {
        let webRequest = WebRequest()
        webRequest.updateContactInfoToServer(body: body) {[weak self] (data) in
            switch data {
            case .success(_):
                self?.delelgate?.contactUpdated(true)
            case .failure(_):
                self?.delelgate?.contactUpdated(false)
            }
        }
    }
    
    // ------------ API Calls End here------------
    
    // MARK:- Get Contact releted Info
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
    
    func updateContactFavouriteInfo() {
        if let contactInfo = contactDetail {
                contactDetail?.isFavorite = !contactInfo.isFavorite
        }
    }
    
    func updateContactInfo(mobileNumber: String?, email: String?) {
        contactDetail?.phoneNumber = mobileNumber
        contactDetail?.email = email
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
