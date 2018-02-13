//
//  ItemTableViewCell.swift
//  RESTInteract
//
//  Created by Akshay  on 18/05/2017.
//  Copyright © 2017 Akshay . All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    
    
    @IBOutlet var foodTypeImage: UIImageView!
    
    @IBOutlet weak var itemName: UILabel!
    
    @IBOutlet weak var daysUntilExpiry: UILabel!
    
    @IBOutlet weak var daysLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
