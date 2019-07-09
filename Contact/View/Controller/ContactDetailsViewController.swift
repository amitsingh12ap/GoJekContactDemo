//
//  ContactDetailsViewController.swift
//  Contact
//
//  Created by Amit Singh on 06/07/19.
//  Copyright © 2019 Amit Singh. All rights reserved.
//

import UIKit
import MessageUI

let kDefaultRowsCount = 4
class ContactDetailsViewController: UIViewController {
    
    var contactId: Int = 0
    var backTitle: String?
    let contactDetailModel = ContactDetailViewModel()
    var isProfileEditing :Bool = false
    var isProfileModified :Bool = false
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var contactDetailTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        titleLabel.text = backTitle
        self.contactDetailTable.tableFooterView = UIView()
        contactDetailModel.delelgate = self
        Utils.showLoading(toView: self.view)
         self.contactDetailModel.getContactDetail(forContactId: self.contactId)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        super.viewWillAppear(true)
    }

    @IBAction func pop(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func EditClicked(_ sender: UIButton) {
        if sender.tag == 100 {
            sender.tag = 101
            self.changeEditButton(status: true)
        }
        else{
            self.changeEditButton(status: false)
            sender.tag = 100
        }
        
    }
    func changeEditButton(status: Bool) {
        if status {
            self.isProfileEditing = true
            self.contactDetailTable.reloadData()
            self.editButton.setTitle("Done", for: .normal)
            
        }
        else{
            self.isProfileEditing = false
            self.isProfileModified = false
            self.contactDetailTable.reloadData()
            self.editButton.setTitle("Edit", for: .normal)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = false
    }
    
}
// MARK:- ContactDetail Protocol
extension ContactDetailsViewController: ContactDetailProtocol {
    func contactUpdated(_ status: Bool) {
        Utils.removeSpinner(toView: self.view)
        if status {
            if isProfileModified {
                self.contactDetailModel.updateContactWithInfo(mobileNumber: self.getProfileInfo()[0] , emailID: self.getProfileInfo()[1]  )
                
                self.changeEditButton(status: false)
            }
            else{
                contactDetailModel.updateContactFavouriteInfo()
            }
        }
        
        // show alert as per the changes
        Utils.showAlert(toController: self, withTitle: status ? Constants.kAlertSuccessTitle : Constants.kAlertErrorTitle, withMessage: status ? Constants.kAlertContactUpdateSuccess : Constants.kAlertContactUpdateFailed)
    }
    
    func didFinishByGettingContactInfo() {
        Utils.removeSpinner(toView: self.view)
        self.contactDetailTable.reloadData()
    }
    
    func failedToGetContactInfo(_ error: Failure) {
        Utils.removeSpinner(toView: self.view)
        Utils.showAlert(toController: self, withTitle: Constants.kAlertErrorTitle, withMessage: error.message)
        
    }
    
    func contactDeleted(_ status: Bool) {
        Utils.removeSpinner(toView: self.view)
        if status {
            self.navigationController?.popViewController(animated: true)
        }
        else{
            Utils.showAlert(toController: self, withTitle: Constants.kAlertErrorTitle, withMessage: Constants.kAlertDeleteContactError)
        }
    }
}
// MARK:- Tableview Delegates
extension ContactDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == tableView.lastIndexpath() {
            Utils.showLoading(toView: self.view)
            contactDetailModel.delegateContact()
        }
    }
}
// MARK:- Tableview DataSources
extension ContactDetailsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kDefaultRowsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.kContactDetailCellIdentifire, for: indexPath) as! ProfileDetailCell
            cell.delelgate = self
            cell.profileImageView.imageFromURL(urlString: contactDetailModel.getProfileUrl())
            cell.fullName.text = contactDetailModel.getFullName()
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row == 1 || indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.kCommonCellIdentifire, for: indexPath) as! CommonEditableCell
            cell.selectionStyle = .none
            if indexPath.row == 1 {
                cell.sideLabel.text = Constants.kMobileNumberTitle
                cell.editableTxtField.text = contactDetailModel.getMobileNumber()
            }
            else{
                cell.sideLabel.text = Constants.kEmailIdTitle
                cell.editableTxtField.text = contactDetailModel.getEmailId()
            }
            cell.editableTxtField.delegate = self
            cell.editableTxtField.tag = indexPath.row
            cell.editableTxtField.isUserInteractionEnabled = isProfileEditing ? true : false
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.kDeleteContactCellIdentifire, for: indexPath) as! DeleteContactCell
        cell.selectionStyle = .none
        return cell
    }
    
}

extension ContactDetailsViewController: UpdateContact{
    func markFavouriteToContact() {
        Utils.showLoading(toView: self.view)
        contactDetailModel.markFavourite()
    }
    
    func updateContactInfo() {
        
    }
    
    func smsClicked() {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.messageComposeDelegate = self
            controller.recipients = [contactDetailModel.getMobileNumber()]
            self.present(controller, animated: true, completion: nil)
        }
        else{
            Utils.showAlert(toController: self, withTitle: Constants.kAlertErrorTitle, withMessage: Constants.kAlertNotSupportedMessage)
        }
    }
    
    func callClicked() {
        if let phoneCallURL = URL(string: "tel://\(contactDetailModel.getMobileNumber())") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
            else{
                Utils.showAlert(toController: self, withTitle: Constants.kAlertErrorTitle, withMessage: Constants.kAlertNotaValidNumber)
            }
        }
        else{
            Utils.showAlert(toController: self, withTitle: Constants.kAlertErrorTitle, withMessage: Constants.kAlertNotSupportedMessage)
        }
    }
    
    func emailClicked() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([contactDetailModel.getEmailId()])
            mail.setMessageBody("<p>Welcome to GoJek</p>", isHTML: true)
            present(mail, animated: true)
        } else {
             Utils.showAlert(toController: self, withTitle: Constants.kAlertErrorTitle, withMessage: Constants.kAlertNotSupportedMessage)
        }
    }
    
    
}
extension ContactDetailsViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case .sent:
            Utils.showAlert(toController: self, withTitle: Constants.kAlertSuccessTitle, withMessage: Constants.kAlertMessageSentSuccess)
        default:
            Utils.showAlert(toController: self, withTitle: Constants.kAlertErrorTitle, withMessage: Constants.kAlertMessageSentFailed)
        }
    }
}
extension ContactDetailsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .sent:
            Utils.showAlert(toController: self, withTitle: Constants.kAlertSuccessTitle, withMessage: Constants.kAlertMailSentSuccess)
        default:
            break
        }
    }
}

extension ContactDetailsViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.isProfileModified = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.isEmpty ?? true {
            Utils.showAlert(toController: self, withTitle: Constants.kAlertErrorTitle, withMessage: Constants.kAlertAddContactEmptyError)
            return
        }
        else if textField.tag == 1 && !Utils.validateMobile(mobile: textField.text ?? "") {
            Utils.showAlert(toController: self, withTitle: Constants.kAlertErrorTitle, withMessage: Constants.kAlertMobileError)
            return
        }
        else if textField.tag == 2 && !Utils.validateEmailId(email: textField.text ?? "") {
            Utils.showAlert(toController: self, withTitle: Constants.kAlertErrorTitle, withMessage: Constants.kAlertEmailError)
            return
        }
        else {
            if(isProfileModified) {
                // update profile
                Utils.showLoading(toView: self.view)
                if self.getProfileInfo().count == 2 {
                    contactDetailModel.updateContactWithInfo(mobileNumber: self.getProfileInfo()[0], emailID: self.getProfileInfo()[1])
                }
            }
        }
    }
    
    func getProfileInfo()-> [String] {
        guard  let mobileNumberCell = self.contactDetailTable.cellForRow(at: (IndexPath.init(row: 1, section: 0))) as? CommonEditableCell else {return []}
        guard let emailIdCell = self.contactDetailTable.cellForRow(at: (IndexPath.init(row: 2, section: 0))) as? CommonEditableCell else {return []}
        
        return [mobileNumberCell.editableTxtField.text ?? "" , emailIdCell.editableTxtField.text ?? ""]
    }
}


extension UITableView {
    func lastIndexpath() -> IndexPath {
        let section = max(numberOfSections - 1, 0)
        let row = max(numberOfRows(inSection: section) - 1, 0)
        return IndexPath(row: row, section: section)
    }
}
