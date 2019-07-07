//
//  ProfileDetailCell.swift
//  Contact
//
//  Created by Amit Singh on 07/07/19.
//  Copyright © 2019 Amit Singh. All rights reserved.
//

import UIKit

class ProfileDetailCell: UITableViewCell {

    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var profileImageView: RoundedImageView!
    
    weak var delelgate: UpdateContact?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func smsClicked(_ sender: Any) {
        self.delelgate?.smsClicked()
    }
    
    @IBAction func callClicked(_ sender: Any) {
        self.delelgate?.callClicked()
    }
    
    @IBAction func emailClicked(_ sender: Any) {
        self.delelgate?.emailClicked()
    }
    
    @IBAction func favClicked(_ sender: Any) {
        self.delelgate?.markFavouriteToContact()
    }
}
