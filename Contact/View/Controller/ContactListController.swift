//
//  ContactListController.swift
//  Contact
//
//  Created by Amit Singh on 05/07/19.
//  Copyright © 2019 Amit Singh. All rights reserved.
//

import UIKit

let kHeaderHeight = 28.0
class ContactListController: UIViewController {
    
    @IBOutlet weak var contactlistTable: UITableView!
    
    let contactModel = ContactListViewModel()
    var contactlistArray:[Contacts] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        contactModel.delelgate=self
        Utils.showLoading(toView: self.view)
        contactModel.fetchContactList()
        self.title = Constants.kNavigationTitleContact
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.contactlistTable.reloadData()
    }
    @IBAction func addContactClicked(_ sender: Any) {
        performSegue(withIdentifier: Constants.kAddContactIdentifire, sender: self)
    }
}
// MARK:- ContactList Protocols
extension ContactListController: ContactListProtocol {
    
    func contactListdidFinishedByGettingContactData() {
        Utils.removeSpinner(toView: self.view)
        self.contactlistTable.reloadData()
    }
    
    func failedToGetContacts(_ error: Failure) {
        Utils.removeSpinner(toView: self.view)
        Utils.showAlert(toController: self, withTitle: Constants.kAlertErrorTitle, withMessage: error.message)
    }
}

// MARK:- Tableview Delegate
extension ContactListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(contactModel.getKeyForSection(section))"
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.kContactDetailIndentifire, sender: self)
    }
}

// MARK:- Tableview DataSources
extension ContactListController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return contactModel.getNumberOfSection()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactModel.getNumberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.kContactlistCellIdentifire, for: indexPath) as! ContactCell
        let contactInfo = contactModel.getContactInfoForIndex(index: indexPath.row, forSection: indexPath.section)
        cell.fullNameLabel.text = "\(contactInfo.firstName) \(contactInfo.lastName)"
        cell.favouriteBtn.isHidden = !contactInfo.favorite
        cell.profileImage.imageFromURL(urlString: contactModel.getProfileImageUrl(profileUrlEndPoint: contactInfo.profilePic))
        return cell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return contactModel.getTitleForHeaderIndex()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(kHeaderHeight)
    }
    
}
// MARK:- Segue
extension ContactListController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.kContactDetailIndentifire {
            let controller:ContactDetailsViewController = segue.destination as! ContactDetailsViewController
            let indexPath = self.contactlistTable.indexPathForSelectedRow
            controller.contactId = contactModel.getContactInfoForIndex(index: indexPath?.row ?? 0, forSection: indexPath?.section ?? 0).id
            controller.backTitle = Constants.kNavigationTitleContact
        }
    }
}
