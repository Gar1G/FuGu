//
//  SettingsViewController.swift
//  RESTInteract
//
//  Created by Akshay  on 16/06/2017.
//  Copyright © 2017 Akshay . All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let defaults = UserDefaults.standard

    @IBOutlet weak var settingsTableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTableview.delegate = self
        settingsTableview.dataSource = self
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        settingsTableview.reloadData()
    }
    
    
    @IBAction func logoutAction(_ sender: UIBarButtonItem) {
        print("Logging out")
        defaults.removeObject(forKey: "UserID")
        defaults.removeObject(forKey: "loggedIn")
        defaults.removeObject(forKey: "CuisinePreferences")
        print("Logged out")
        performSegue(withIdentifier: "logoutSegue", sender: sender)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = settingsTableview.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as! SettingsTableViewCell
        
        if indexPath.row == 0{
            cell.settingLabel.text = "Connect to Fridge"
        }
        else if (indexPath.row == 1){
            cell.settingLabel.text = "Connect to Bin"
        }
        else{
            cell.settingLabel.text = "Cuisine Preferences"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2{
            performSegue(withIdentifier: "settingsSegue", sender: self)
            
        }
        else{
            print("Connect to Fridge/Bin")
            performSegue(withIdentifier: "instructionSegue", sender: self)

        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingsSegue", let destination = segue.destination as? PreferencesViewController{
            destination.done = true
        }
            
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
