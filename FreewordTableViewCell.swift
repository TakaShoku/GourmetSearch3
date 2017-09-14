//
//  FreewordTableViewCell.swift
//  GourmetSearch3
//
//  Created by 曽和寛貴 on 2017/09/12.
//  Copyright © 2017年 曽和寛貴. All rights reserved.
//

import UIKit

class FreewordTableViewCell: UITableViewCell {

    
    @IBOutlet weak var freeword: UITextField!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
