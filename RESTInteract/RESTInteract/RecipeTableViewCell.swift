//
//  RecipeTableViewCell.swift
//  RESTInteract
//
//  Created by Akshay  on 20/02/2017.
//  Copyright © 2017 Akshay . All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var recipeName: UILabel!
    
    @IBOutlet weak var sourceName: UILabel!
    
    var gradient: CAGradientLayer = CAGradientLayer()

    override func awakeFromNib() {
        super.awakeFromNib()
        gradient.frame = imgView.frame
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.0,0.95]
        imgView.layer.insertSublayer(gradient, at: 0)
        // Initialization code
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgView.image = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
