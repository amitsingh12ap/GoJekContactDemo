//
//  AddContactViewController.swift
//  Contact
//
//  Created by Amit Singh on 07/07/19.
//  Copyright © 2019 Amit Singh. All rights reserved.
//

import UIKit

let cellNameArray = ["First Name","Last Name","Mobile","Email"]
class AddContactViewController: UIViewController {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var contactTableView: UITableView!
    var addContactVM = AddContactViewModel()
    var contactInfo = [String: Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addContactVM.delelgate = self
        // Do any additional setup after loading the view.
        self.contactTableView.tableFooterView = UIView()
        
    }
    
    @IBAction func cancelClcked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneClicked(_ sender: Any) {
        if contactInfo.count < 4{
            Utils.showAlert(toController: self, withTitle: Constants.kAlertErrorTitle, withMessage: Constants.kAlertAddContactEmptyError)
        }
        else {
            Utils.showLoading(toView: self.view)
            
            let contact = ConactInfo.init(contactId: nil, firstName: contactInfo["First Name"] as? String, lastName: contactInfo["Last Name"] as? String, email: contactInfo["Email"] as? String, phoneNumber: contactInfo["Mobile"] as? String, profileImageUrl: nil, isFavorite: false, createdAt: nil, updatedAt: nil)
            addContactVM.createContact(contactmodel: contact)
            
        }
        
    }
    
}

extension AddContactViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellNameArray.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.kAddContactCellIdentifire, for: indexPath) as! AddContactCell
            cell.selectionStyle = .none
            return cell
        }
         let cell = tableView.dequeueReusableCell(withIdentifier: Constants.kCommonCellIdentifire, for: indexPath) as! CommonEditableCell
        cell.sideLabel.text = cellNameArray[indexPath.row - 1]
        cell.editableTxtField.tag = indexPath.row
        cell.editableTxtField.delegate = self
        cell.selectionStyle = .none
        return cell
    }
}

extension AddContactViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.isEmpty ?? true {
            Utils.showAlert(toController: self, withTitle: Constants.kAlertErrorTitle, withMessage: Constants.kAlertAddContactEmptyError)
            return
        }
        else if textField.tag == 3 && !Utils.validateMobile(mobile: textField.text ?? "") {
            Utils.showAlert(toController: self, withTitle: Constants.kAlertErrorTitle, withMessage: Constants.kAlertMobileError)
            return
        }
        else if textField.tag == 4 && !Utils.validateEmailId(email: textField.text ?? "") {
            Utils.showAlert(toController: self, withTitle: Constants.kAlertErrorTitle, withMessage: Constants.kAlertEmailError)
            return
        }
        contactInfo[cellNameArray[textField.tag - 1]] = textField.text ?? ""
    }
}

extension AddContactViewController: AddContactProtocol {
    func contactCreated(status: Bool) {
        if !status {
            self.perform(#selector(self.showFailedMessage), with: nil, afterDelay: 1)
        }
        else {
            Utils.removeSpinner(toView: self.view)
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func showSuccessMessage() {
        Utils.showAlert(toController: self, withTitle: Constants.kAlertSuccessTitle , withMessage: Constants.kAlertContactCreateSuccess)
    }
    
    @objc func showFailedMessage() {
        Utils.showAlert(toController: self, withTitle: Constants.kAlertErrorTitle , withMessage:Constants.kAlertContactCreateFailed )
    }
}
