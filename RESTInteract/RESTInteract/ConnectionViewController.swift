//
//  ConnectionViewController.swift
//  RESTInteract
//
//  Created by Akshay  on 17/06/2017.
//  Copyright © 2017 Akshay . All rights reserved.
//

import UIKit

class ConnectionViewController: UIViewController {
    

    
    @IBOutlet weak var connectionWebview: UIWebView!

    //var urlString : String = "http://192.168.4.1"
    var urlString : String = "http://www.google.com"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Device Connection"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        connectionWebview.loadRequest(request)
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
