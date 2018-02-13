//
//  LoginViewController.swift
//  RESTInteract
//
//  Created by Akshay  on 25/05/2017.
//  Copyright © 2017 Akshay . All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let defaults = UserDefaults.standard

    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func loginAction(_ sender: UIButton) {
        guard let username = usernameField.text, username != "" else{
            print("No Name")
            return
        }
        
        //Shifts hash value by 32 bits
        //let shift = 4294967296 as Int32
        let userid = abs(username.hash)/4294967296
        let pwd = passwordField.text
        let loginURL: String = "http://foodappee.azurewebsites.net/LoginUser?userid=\(userid)&password=\(pwd!)"
        login(url: loginURL, id: userid)
    }
    
    func login(url: String, id: Int){
        
        
        var credentialStatus: Int = 0 //0: Credentials fine, 1: UserID OR Password incorrect, 2: User already exists
        var loginStatus: Int = 0 //0: Not Success, 1: Login success, 2: Register Success
        
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: urlRequest){ (data, response, error) in
            
            if error != nil{
                print(error!)
                return
            }
            do{
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject] //gives us json object in form of dictionary of string to anyobject
                credentialStatus = json["credential_status"] as! Int
                loginStatus = json["login_status"] as! Int
                
                DispatchQueue.main.async {
                    switch credentialStatus{
                    case 1:
                        //userid or password incorrect
                        print("userid or password incorrect")
                        let alert = UIAlertController(title: "Incorrect User ID or Password", message: "Please enter valid login credentials", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        alert.view.tintColor = UIColor(red: 1.0, green: 0, blue: 0.3, alpha: 1.0)
                        self.present(alert, animated: true, completion: nil)
                        break
                    default:
                        if(loginStatus == 1){
                            let loggedIn = 1
                            self.defaults.set(loggedIn, forKey: "loggedIn")
                            self.defaults.set(id, forKey: "UserID")
                            self.performSegue(withIdentifier: "preferenceSegue", sender: self)
                        }
                        else{
                            let alert = UIAlertController(title: "Login Problem", message: "There was a problem trying to log you in. Please try again later.", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            alert.view.tintColor = UIColor(red: 1.0, green: 0, blue: 0.3, alpha: 1.0)
                            self.present(alert, animated: true, completion: nil)
                            //login status 0
                            //throw alert
                        }
                        break
                    }
                }
            }
            catch let error{
                print(error)
            }
            
        }
        task.resume()
        
    }
    
    func autoLogin(){
        if defaults.object(forKey: "loggedIn") != nil {
            print("Logged in!")
            performSegue(withIdentifier: "loginSegue", sender: self)
        } else {
            performSegue(withIdentifier: "loginSegue", sender: self)
            print("loggedIn: not set")
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 10
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        autoLogin()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
