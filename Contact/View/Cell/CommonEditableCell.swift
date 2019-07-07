//
//  CommonEditableCell.swift
//  Contact
//
//  Created by Amit Singh on 07/07/19.
//  Copyright © 2019 Amit Singh. All rights reserved.
//

import UIKit

class CommonEditableCell: UITableViewCell {

    @IBOutlet weak var editableTxtField: UITextField!
    @IBOutlet weak var sideLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
