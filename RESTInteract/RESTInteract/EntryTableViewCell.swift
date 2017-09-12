//
//  EntryTableViewCell.swift
//  RESTInteract
//
//  Created by Akshay  on 22/05/2017.
//  Copyright © 2017 Akshay . All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {


    
    @IBOutlet weak var ingredientLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
