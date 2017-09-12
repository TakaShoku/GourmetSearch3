//
//  ShopItemTableViewCell.swift
//  GourmetSearch3
//
//  Created by 曽和寛貴 on 2017/09/09.
//  Copyright © 2017年 曽和寛貴. All rights reserved.
//

import UIKit

class ShopItemTableViewCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var iconContainer: UIView!
    @IBOutlet weak var coupon: UILabel!
    @IBOutlet weak var station: UILabel!
    
    
    @IBOutlet weak var nameHeight: NSLayoutConstraint!
    @IBOutlet weak var stationWidth: NSLayoutConstraint!
    @IBOutlet weak var stationX: NSLayoutConstraint!
    
    
    var shop: Shop = Shop() {
        
        didSet {
            
            name.text = shop.name
            var x: CGFloat = 0
            let margin: CGFloat = 10
            if shop.hasCoupon {
                coupon.isHidden = false
                x += coupon.frame.size.width + margin
                
                coupon.layer.cornerRadius = 4
                coupon.clipsToBounds = true
            } else {
                coupon.isHidden = true
            }
            
            if shop.station != nil {
                station.isHidden = false
                station.text = shop.station
                stationX.constant = x
                
                let size = station.sizeThatFits(CGSize(
                    width: CGFloat.greatestFiniteMagnitude,
                    height: CGFloat.greatestFiniteMagnitude))
                if x + size.width + margin > iconContainer.frame.width {
                    stationWidth.constant = iconContainer.frame.width - x
                } else {
                    stationWidth.constant = size.width + margin
                }
                
                station.clipsToBounds = true
                station.layer.cornerRadius = 4
            } else {
                station.isHidden = true
            }
        }
    
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let maxFrame = CGRect (
            x: 0,
            y: 0,
            width: name.frame.size.width,
            height: CGFloat.greatestFiniteMagnitude)
        let actualFrame = name.textRect(forBounds: maxFrame, limitedToNumberOfLines: 2)
        
        nameHeight.constant = actualFrame.size.height
    }

}
