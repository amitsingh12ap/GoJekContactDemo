//
//  Utils.swift
//  Contact
//
//  Created by Amit Singh on 05/07/19.
//  Copyright © 2019 Amit Singh. All rights reserved.
//

import Foundation
import UIKit



struct Utils {
    
    static func showAlert(toController controller: UIViewController, withTitle title: String?, withMessage message: String?){
        
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title:Constants.kOkTitle, style: .default, handler: nil))
        controller.present(alertController, animated: true, completion: nil)
    }
    
    static func showLoading(toView view: UIView) {
        guard let keyWindow = UIApplication.shared.keyWindow else {return}
        keyWindow.rootViewController?.showSpinner(onView: view)
    }
    
    static func removeSpinner(toView view: UIView){
        guard let keyWindow = UIApplication.shared.keyWindow else {return}
        keyWindow.rootViewController?.removeSpinner()
    }
    
    static func validateEmailId(email: String)-> Bool {
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: email)
        return result
    }
    
    static func validateMobile(mobile: String) -> Bool {
        let phoneRegex = "^(|(00))[0-9]{6,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: mobile)
    }
    
    
    
    
}
