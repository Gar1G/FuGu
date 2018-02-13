//
//  WasteFeedbackTableViewCell.swift
//  RESTInteract
//
//  Created by Akshay  on 10/06/2017.
//  Copyright © 2017 Akshay . All rights reserved.
//

import UIKit

class WasteFeedbackTableViewCell: UITableViewCell {

    @IBOutlet weak var YourProgress: UILabel!
    
    @IBOutlet weak var feedbackLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
