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
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contactDetailTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        titleLabel.text = backTitle
        self.contactDetailTable.tableFooterView = UIView()
        contactDetailModel.delelgate = self
         self.contactDetailModel.getContactDetail(forContactId: self.contactId)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        super.viewWillAppear(true)
    }

    @IBAction func pop(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func Edit(_ sender: Any) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = false
    }
    
}
// MARK:- ContactDetail Protocol
extension ContactDetailsViewController: ContactDetailProtocol {
    func contactUpdated(_ status: Bool) {
        
        DispatchQueue.main.async {
            Utils.showAlert(toController: self, withTitle: status ? Constants.kAlertSuccessTitle : Constants.kAlertErrorTitle, withMessage: status ? Constants.kAlertContactUpdateSuccess : Constants.kAlertContactUpdateFailed)
        }
    }
    @objc func showFavouriteAlert(status: Bool) {
        
    }
    
    func didFinishByGettingContactInfo() {
        DispatchQueue.main.async {
            self.contactDetailTable.reloadData()
        }
    }
    
    func failedToGetContactInfo(_ error: Failure) {
        DispatchQueue.main.async {
            Utils.showAlert(toController: self, withTitle: Constants.kAlertErrorTitle, withMessage: error.message)
        }
    }
}

extension ContactDetailsViewController: UITableViewDelegate {
    
}

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
            cell.editableTxtField.isUserInteractionEnabled = false
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.kDeleteContactCellIdentifire, for: indexPath) as! DeleteContactCell
        cell.selectionStyle = .none
        return cell
    }
    
}

extension ContactDetailsViewController: UpdateContact{
    func markFavouriteToContact() {
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
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            
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
