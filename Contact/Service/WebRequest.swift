//
//  WebRequest.swift
//  Contact
//
//  Created by Amit Singh on 05/07/19.
//  Copyright © 2019 Amit Singh. All rights reserved.
//

import UIKit

class WebRequest: NSObject,Requestable {
    // fetch all contacts
    func fetchAllContactFromServer(callback: @escaping CompletionHandler){
        let url = EndPoint.getAllContacts.path
        self.callApiToGetData(url: url) { (data) in
            switch data {
                case .success(let contactData):
                    do {
                        let decoder = JSONDecoder()
                        let contactList = try decoder.decode(Array<Contacts>.self, from: contactData)
                        callback(.success(contactList))
                    } catch _ {
                        callback(.failure(.decodeFailure))
                    }
                case .failure(_):
                    callback(.failure(.apiFailure))
                }
            }
    }
    // fetch contact detail
    func fetchContactDetailFromServer(contactId:Int, callback: @escaping ContactDetailCallBack) {
        let url = EndPoint.getContactById(Id: contactId).path
        self.callApiToGetData(url: url) { (data) in
            switch data {
                case .success(let contactData):
                do {
                    let decoder = JSONDecoder()
                    let contactInfo = try decoder.decode(ConactInfo.self, from: contactData)
                    callback(.success(contactInfo))
                } catch _ {
                    callback(.failure(.decodeFailure))
                }
                case .failure(_):
                    callback(.failure(.apiFailure))
                }
            }
        }
    
    func updateContactInfoToServer(body: ConactInfo?, callback: @escaping Handler) {
        guard let contact = body else {return}
        guard let contactId = contact.contactId else {return}
        let url = EndPoint.updateContactDetailWithContactId(contactId: contactId).path
        do {
            let parms = try body.asDictionary()
            self.callApiToUpdate(methodType: .put, url: url, parameters: parms) { (data) in
                switch data {
                case .success(let response):
                    callback(.success(response))
                case .failure(let responseCode):
                    callback(.failure(responseCode))
                }
            }
        }
        catch _ {
            callback(.failure(500))
        }
    }
    
    func createContactToServer(body: ConactInfo, callback: @escaping Handler) {
        let url = EndPoint.getAllContacts.path
        do {
            let parms = try body.asDictionary()
            self.callApiToUpdate(methodType: .post, url: url, parameters: parms) { (data) in
                switch data {
                case .success(let response):
                    callback(.success(response))
                case .failure(let responseCode):
                    callback(.failure(responseCode))
                }
            }
        }
        catch _ {
            callback(.failure(500))
        }
    }
}
    
extension WebRequest {
    private func callApiToGetData(url: String, callback: @escaping DefaultCallBack){
        request(method: .get, url: url, params: nil) { (data) in
            
            switch data {
            case .success(let result):
                callback(.success(result))
                break
            case .failure(_):
                callback(.failure(.apiFailure))
                break
            }
        }
    }
    
    private func callApiToUpdate(methodType: Method, url: String, parameters:[String:Any], callback: @escaping Handler){
        request(method: methodType, url: url, params: parameters) { (data) in
            callback(data)
        }
    }
    
}




