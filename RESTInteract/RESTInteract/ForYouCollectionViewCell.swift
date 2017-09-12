//
//  ForYouCollectionViewCell.swift
//  RESTInteract
//
//  Created by Akshay  on 18/05/2017.
//  Copyright © 2017 Akshay . All rights reserved.
//

import UIKit

class ForYouCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var recipeImage: UIImageView!
    
    @IBOutlet var yourRecipeName: UILabel!
    
    
    @IBOutlet var gradientView: GradientView!
    
    
    var gradient: CAGradientLayer = CAGradientLayer()
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        gradient.frame = recipeImage.frame
//        gradient.colors = [UIColor.clear, UIColor.black]
//        
//        gradient.locations = [0.0, 0.55]
//        recipeImage.layer.insertSublayer(gradient, at: 0)
//        layoutIfNeeded()
//    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        gradient.frame = recipeImage.frame
        gradient.colors = [UIColor.clear, UIColor.black]
        
        gradient.locations = [0.0, 0.55]
        self.recipeImage.layer.insertSublayer(gradient, at: 0)

    }
    
   
}
