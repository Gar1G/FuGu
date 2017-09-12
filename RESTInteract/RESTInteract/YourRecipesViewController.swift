//
//  YourRecipesViewController.swift
//  RESTInteract
//
//  Created by Akshay  on 07/06/2017.
//  Copyright © 2017 Akshay . All rights reserved.
//

import UIKit
import CoreData

class YourRecipesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var yourRecipesTableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var yourRecipes: [UserRecipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        yourRecipesTableView.delegate = self
        yourRecipesTableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //function to get data
        yourRecipesTableView.reloadData()
    }
    
    func getData(){
        do{
            yourRecipes = try context.fetch(UserRecipe.fetchRequest())
        }
        catch{
            print("Fetching Failed")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yourRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = yourRecipesTableView.dequeueReusableCell(withIdentifier: "UserRecipeCell", for: indexPath) as! RecipeTableViewCell
        let data = yourRecipes[indexPath.row].image
        cell.recipeName.text = yourRecipes[indexPath.row].name!

        cell.imgView.image = UIImage(data: (data!) as Data)
        cell.sourceName.text = ""
        return cell
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
