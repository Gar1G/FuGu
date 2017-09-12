//
//  RegisterViewController.swift
//  RESTInteract
//
//  Created by Akshay  on 25/05/2017.
//  Copyright © 2017 Akshay . All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var userNameField: UITextField!
    
    @IBOutlet weak var firstNameField: UITextField!
    
    @IBOutlet weak var lastNameField: UITextField!
    
    
    @IBOutlet weak var emailField: UITextField!
    
    
    @IBOutlet weak var passwordField: UITextField!
    
    
    @IBOutlet weak var repeatPassword: UITextField!
    
    
    @IBOutlet weak var registerButton: UIButton!
    
    
    @IBAction func backToLogin(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        registerButton.layer.cornerRadius = 10
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        

        // Do any additional setup after loading the view.
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    

    @IBAction func registerUser(_ sender: UIButton) {
        
        guard let firstname = firstNameField.text, firstname != "" else{
            print("Empty First Name Field")
            let alert = UIAlertController(title: "No First Name", message: "Please enter your first name", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            alert.view.tintColor = UIColor(red: 1.0, green: 0, blue: 0.3, alpha: 1.0)
            self.present(alert, animated: true, completion: nil)
            return
        }
        guard let lastname = lastNameField.text, lastname != "" else{
            print("Empty Last Name Field")
            let alert = UIAlertController(title: "No Last Name", message: "Please enter your last name", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            alert.view.tintColor = UIColor(red: 1.0, green: 0, blue: 0.3, alpha: 1.0)
            return
            
        }
        guard let email = emailField.text, email != "" else{
            print("Empty Email Field")
            let alert = UIAlertController(title: "No Email Address", message: "Please enter your email address", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            alert.view.tintColor = UIColor(red: 1.0, green: 0, blue: 0.3, alpha: 1.0)
            return
        }
        guard let username = userNameField.text, username != "" else{
            print("Empty Username Field")
            let alert = UIAlertController(title: "No User Name", message: "Please enter a user name", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            alert.view.tintColor = UIColor(red: 1.0, green: 0, blue: 0.3, alpha: 1.0)
            return
        }
        guard let password = passwordField.text, password != "" else{
            print("Empty Password")
            let alert = UIAlertController(title: "No password", message: "Please enter a password", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            alert.view.tintColor = UIColor(red: 1.0, green: 0, blue: 0.3, alpha: 1.0)
            return
        }
        guard let repPassword = repeatPassword.text, repPassword != "" else{
            print("Must Re-Enter Password")
            let alert = UIAlertController(title: "Missing repeated password", message: "Please repeat your password", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            alert.view.tintColor = UIColor(red: 1.0, green: 0, blue: 0.3, alpha: 1.0)
            return
        }
        
        
        let userid = abs(username.hash)/4294967296
        
        if(password != repPassword){
            print("Passwords do not match")
            let alert = UIAlertController(title: "Passwords do not match", message: "Please make sure your passwords match", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            alert.view.tintColor = UIColor(red: 1.0, green: 0, blue: 0.3, alpha: 1.0)
            return
        }
        //self.performSegue(withIdentifier: "registerSegue", sender: self)
        
        let registerURL: String = "http://foodappee.azurewebsites.net/RegisterUser?userid=\(userid)&email=\(email)&firstName=\(firstname)&lastName=\(lastname)&password=\(password)"
        register(url: registerURL)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func register(url: String){
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
                    case 2:
                        //userid or password incorrect
                        print("Username already exists")
                        let alert = UIAlertController(title: "User already exists", message: "Please choose another user name", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        alert.view.tintColor = UIColor(red: 1.0, green: 0, blue: 0.3, alpha: 1.0)
                        break
                    default:
                        if(loginStatus == 2){
                            self.performSegue(withIdentifier: "registerSegue", sender: self)
                        }
                        else{
                            let alert = UIAlertController(title: "Problem Registering", message: "There was a pronlem registering you. Please try again later.", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            alert.view.tintColor = UIColor(red: 1.0, green: 0, blue: 0.3, alpha: 1.0)
                            //login status 0
                            //throw error
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
