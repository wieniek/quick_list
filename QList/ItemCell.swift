//
//  ItemCell.swift
//  QList
//
//  Created by Home on 1/23/18.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit
import BEMCheckBox
import ChameleonFramework

protocol ItemCellDelegate {
    func didUpdateCell(withLabel label: UILabel, andCheckmark checkmark: BEMCheckBox)
}

class ItemCell: UITableViewCell {
    
    var delegate: ItemCellDelegate?
    
    @IBOutlet weak var itemCheckmark: BEMCheckBox!
    
    //@IBOutlet weak var itemCheckmark: UISwitch!
    @IBOutlet weak var itemLabel: UILabel!
    
    @IBAction func toggleCheckmark(_ sender: BEMCheckBox) {
        
        delegate?.didUpdateCell(withLabel: itemLabel, andCheckmark: itemCheckmark)
    }
    
//    @IBAction func toggleCheckmark(_ sender: UISwitch) {
//        print("Checkmark toggled.....")
//        delegate?.didUpdateCell(withLabel: itemLabel, andCheckmark: itemCheckmark)
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        itemCheckmark.onAnimationType = .bounce
        itemCheckmark.offAnimationType = .bounce
        itemCheckmark.boxType = .square
        itemCheckmark.onTintColor = .black
        itemCheckmark.onCheckColor = .black
        itemCheckmark.animationDuration = 0
        // backgroundColor = HexColor("4CD964") // iOS Green
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

// Extending string in order to draw character as image inside UIView
extension String {
    func image() -> UIImage? {
        let size = CGSize(width: 25, height: 25)
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        UIColor.clear.set()
        let rect = CGRect(origin: CGPoint(), size: size)
        UIRectFill(CGRect(origin: CGPoint(), size: size))
        (self as NSString).draw(in: rect, withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
