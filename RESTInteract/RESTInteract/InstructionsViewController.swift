//
//  InstructionsViewController.swift
//  RESTInteract
//
//  Created by Akshay  on 17/06/2017.
//  Copyright © 2017 Akshay . All rights reserved.
//

import UIKit

class InstructionsViewController: UIViewController {

    
    @IBOutlet weak var instructionsImage: UIImageView!
    
    
    @IBOutlet weak var connectionButton: UIButton!
    
    
    @IBAction func connectAction(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Instructions"
        connectionButton.layer.cornerRadius = 10

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
