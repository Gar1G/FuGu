//
//  RecipeEntryViewController.swift
//  RESTInteract
//
//  Created by Akshay  on 20/05/2017.
//  Copyright © 2017 Akshay . All rights reserved.
//

import UIKit
import CoreData


class RecipeEntryViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var ingredients = [String]()
    var recipeName: String = ""
    
    
    @IBOutlet weak var recipeImage: UIImageView!
    
    let picker = UIImagePickerController()
    
    
    @IBOutlet weak var recipeNameField: UITextField!
    
    @IBOutlet var modalView: UIView!

    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // RECIPE IMAGE PICKER
    @IBAction func photoPicker(_ sender: UIButton) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        recipeImage.image = chosenImage
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func saveDismiss(_ sender: UIBarButtonItem) {
        recipeName = recipeNameField.text!
        
        //Check that there is a recipe name and ingredients
        if(recipeName != "" && !(ingredients.isEmpty)){
            print("success")
            let entity = NSEntityDescription.entity(forEntityName: "UserRecipe", in: self.context)
            let recipe = NSManagedObject(entity: entity!, insertInto: context)
            recipe.setValue(recipeName, forKey: "name")
            var ingredientString: String = String()
            for i in ingredients{
                ingredientString = ingredientString + " \(i)"
            }
            recipe.setValue(ingredientString, forKey: "ingredients")
            let imageData = UIImagePNGRepresentation(recipeImage.image!) as NSData?
            recipe.setValue(imageData, forKey: "image")
            do{
                try self.context.save()
                print("save success")
            }
            catch let error as NSError{
                print("Could not save \(error), \(error.userInfo)")
            }
            
            //Save into db of user recipes
        }
        else{
            print("fail")
            //throw error that incomplete form
        }
        
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var entryTableView: UITableView!
    
    @IBAction func textFieldBeginEditing(_ sender: UITextField) {
        entryTextField.text = ""
    }
    @IBAction func addIngredient(_ sender: UIButton) {
        
        let entrytext = entryTextField.text ?? ""
        
        if entrytext == ""{
            print("Text Field Empty")
        }
        else{
            ingredients.append(entrytext)
            entryTableView.beginUpdates()
            entryTableView.insertRows(at: [IndexPath.init(row: ingredients.count - 1, section: 0)], with: .automatic)
            entryTableView.endUpdates()
        }
        entryTextField.text = ""
        entryTextField.resignFirstResponder()
        
        
        
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    
    @IBOutlet weak var entryTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        entryTableView.dataSource = self
        entryTableView.delegate = self
        picker.delegate = self
        modalView.layer.cornerRadius = 10
        modalView.layer.masksToBounds = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RecipeEntryViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    func dismissKeyboard(){
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
        //return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = entryTableView.dequeueReusableCell(withIdentifier: "IngredientEntryCell", for: indexPath) as! EntryTableViewCell
        cell.ingredientLabel.text = ingredients[indexPath.row]
        return cell
        
    }
    
    func deleteCell(cell: UITableViewCell){
        if let deletionIndexPath = entryTableView.indexPath(for: cell){
            ingredients.remove(at: deletionIndexPath.row)
            entryTableView.deleteRows(at: [deletionIndexPath], with: .automatic)
        }
        
    }


}
