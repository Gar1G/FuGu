//
//  RecipeWebViewController.swift
//  RESTInteract
//
//  Created by Akshay  on 30/04/2017.
//  Copyright © 2017 Akshay . All rights reserved.
//

import UIKit

class RecipeWebViewController: UIViewController, UIWebViewDelegate {

    
    @IBOutlet weak var recipeWebView: UIWebView!
    var urlString = String()
    var recipeName = String()
    
    override func viewWillAppear(_ animated: Bool) {
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        recipeWebView.loadRequest(request)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = recipeName
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
