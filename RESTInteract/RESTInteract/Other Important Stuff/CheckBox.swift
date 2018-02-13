//
//  CheckBox.swift
//  RESTInteract
//
//  Created by Akshay  on 26/05/2017.
//  Copyright © 2017 Akshay . All rights reserved.
//

import UIKit

class CheckBox: UIButton {
    
    var checkedImage = UIImage(named: "salad")
    var uncheckedImage = UIImage(named: "chicken")
    
    
    
    var isChecked: Bool = false{
        didSet{
            if isChecked == true{
                //self.setImage(checkedImage, for: .normal)
                self.setBackgroundImage(checkedImage, for: .normal)
            }
            else{
                //self.setImage(uncheckedImage, for: .normal)
                self.setBackgroundImage(uncheckedImage, for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        
        self.addTarget(self, action: #selector(CheckBox.buttonClicked(sender:)), for: UIControlEvents.touchUpInside)
        self.isChecked = false
        
    }
    
    func buttonClicked(sender: UIButton){
        print("clicked")
        if sender == self{
            isChecked = !isChecked
        }
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
