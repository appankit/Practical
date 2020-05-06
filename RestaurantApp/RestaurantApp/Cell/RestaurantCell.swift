//
//  AppConstant.swift
//  RestaurantApp
//
//  Created by iMac on 05/05/20.
//  Copyright © 2020 iMac. All rights reserved.

import UIKit

class RestaurantCell: UITableViewCell {

    @IBOutlet weak var btnClick: UIButton!
    @IBOutlet weak var imgBanner: UIImageView!
    @IBOutlet weak var lblRestaurantName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblNum: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
