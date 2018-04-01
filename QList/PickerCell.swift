//
//  PickerCell.swift
//  QList
//
//  Created by Home on 3/19/18.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit

class PickerCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = colorPastel4?.darken(byPercentage: 0.1)
        contentView.backgroundColor = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder): has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}
