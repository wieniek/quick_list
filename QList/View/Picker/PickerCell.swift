//
//  PickerCell.swift
//  QList
//
//  Created by Home Mac on 4/2/18.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit

class PickerCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = colorPastel4?.darken(byPercentage: 0.1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
