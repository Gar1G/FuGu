//
//  RecipesViewController.swift
//  RESTInteract
//
//  Created by Akshay  on 30/04/2017.
//  Copyright © 2017 Akshay . All rights reserved.
//

import UIKit

class RecipesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var recipeTableView: UITableView!
    
    var recipes: [Recipe]? = []
    
    var items: [String]? = []
    
    @IBOutlet weak var searchField: UISearchBar!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        items = ["chicken", "spinach", "salmon"]
        fetchRecipes(items: items!)
        recipeTableView.dataSource = self
        recipeTableView.delegate = self
        
       

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recipes?.count ?? 0  //If recipe doesnt exist, use 0 rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recipeTableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeTableViewCell
        
        cell.recipeName.text = self.recipes?[indexPath.item].name
        cell.imgView.downloadImage(from: (self.recipes?[indexPath.item].imageURL!)!)
        
        
        // Configure the cell...
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("hello")
    }
    
    
    private func fetchRecipes(items: [String]){
        
        var itemString = ""
        
        for i in items{
            itemString = itemString + "allowedIngredient[]=\(i)&"
        }
        
        //let recipeURL: String = "http://api.yummly.com/v1/api/recipes?_app_id=040ca89b&_app_key=b52b549137b851a8e6fe14e451c86218&allowedIngredient[]=salmon&maxResult=40"
        
        let recipeURL: String = "http://api.yummly.com/v1/api/recipes?_app_id=040ca89b&_app_key=b52b549137b851a8e6fe14e451c86218&\(itemString)maxResult=50"
        print(recipeURL)
        
        let urlRequest = URLRequest(url: URL(string: recipeURL)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest){ (data, response, error) in
            
            if error != nil{
                print(error!)
                return
            }
            
            
            self.recipes = [Recipe]()
            do{
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject] //gives us json object in form of dictionary of string to anyobject
                
                if let recipesFromJson = json["matches"] as? [[String: AnyObject]]{
                    
                    for recipeFromJson in recipesFromJson{
                        
                        let recipe = Recipe()
                        //extract values we want for each recipe
                        
                        if let title = recipeFromJson["recipeName"] as? String, let dictToImage = recipeFromJson["imageUrlsBySize"] as? [String: AnyObject]{
                            recipe.name = title
                            
                            
                            if let urlToImage = dictToImage["90"] as? String{
                                recipe.imageURL = urlToImage
                            }
                        }
                        self.recipes?.append(recipe)
                    }
                }//array of dictionary
                
                DispatchQueue.main.async {
                    self.recipeTableView.reloadData()
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


