//
//  ContactListViewModel.swift
//  Contact
//
//  Created by Amit Singh on 05/07/19.
//  Copyright © 2019 Amit Singh. All rights reserved.
//

import Foundation
import UIKit

class ContactListViewModel: NSObject {
    
    weak var delelgate: ContactListProtocol?
    var groupedContactList = [Character: [Contacts]]()
    
    func fetchContactList() {
        guard let window = UIApplication.shared.keyWindow else { return  }
        Utils.showLoading(toViewController: window)
        let webRequest = WebRequest()
        webRequest.fetchAllContactFromServer {[weak self](result) in
            guard let self = self else { return }
            switch result {
            case .success(var contactlistData):
                self.groupedContactLists(contactListData: &contactlistData)
                self.delelgate?.contactListdidFinishedByGettingContactData()
            case .failure(let failureReason):
                self.delelgate?.failedToGetContacts(failureReason)
            }
        }
    }
    
}

extension ContactListViewModel {
    private func groupedContactLists(contactListData: inout [Contacts]){
        contactListData.sort {
            $0.firstName < $1.firstName
        }
        
        var tempArray = [Contacts]()
        for contact in contactListData {
            let firstChar = Array(contact.firstName)[0]
            if !groupedContactList.keys.contains(firstChar) && tempArray.count > 0 {
                tempArray.removeAll()
            }
            tempArray.append(contact)
            groupedContactList[firstChar] = tempArray
        }
    }
    
    private func getContactsForSection(section: Int)->[Contacts]{
        return groupedContactList.keys.sorted().compactMap{ groupedContactList[$0] }[section]
    }
    
}

extension ContactListViewModel {
    func getKeyForSection(_ section: Int) -> Character {
        let keys = groupedContactList.keys.sorted()
        return Array(keys)[section]
    }
    
    func getNumberOfSection()-> Int{
        return groupedContactList.keys.count
    }
    
    func getTitleForHeaderIndex() -> [String] {
        return groupedContactList.keys.sorted().map{String($0)}
    }
    
    func getNumberOfRowsInSection(section: Int) -> Int{
        return self.getContactsForSection(section: section).count
    }
    
    func getContactInfoForIndex(index: Int, forSection section: Int)-> Contacts {
        let contacts = self.getContactsForSection(section: section)
        return contacts[index]
    }
    
    func getProfileImageUrl(profileUrlEndPoint: String) -> String{
        return "\(Domain.baseUrl())\(profileUrlEndPoint)"
    }
}

