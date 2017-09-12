//
//  SearchViewController.swift
//  RESTInteract
//
//  Created by Akshay  on 29/05/2017.
//  Copyright © 2017 Akshay . All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UISearchResultsUpdating, UISearchBarDelegate{
    
    
    
    @IBOutlet weak var recipeSearchTableView: UITableView!
    
    @IBAction func search(_ sender: UIBarButtonItem) {
        testView.isHidden = false
        self.searchController.isActive = true
    }
    
    
    @IBOutlet weak var testView: UIView!
    
    
    var recipes: [Recipe]? = []
    var searchController: UISearchController!
    let sections: [String] = ["Your Recipes", "Recipes By Yummly"]
    let images : [UIImage] = [#imageLiteral(resourceName: "chicken"), #imageLiteral(resourceName: "salad"), #imageLiteral(resourceName: "paneer")]
    
    var items: [String]? = []
    var searchItems: [String]? = []
    
    var shouldShowSearchResults = true


    override func viewDidLoad() {
        super.viewDidLoad()
        items = ["jam", "bread"]
        fetchRecipes(items: items!)
        recipeSearchTableView.dataSource = self
        recipeSearchTableView.delegate = self
        configureSearchController()
        testView.isHidden = true
        //self.recipeSearchTableView.setContentOffset(CGPoint(x:0, y:44), animated: true)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureSearchController(){
        //tableview that displays search results exists in same controller
        //nil value means existing view controller will display results
        searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Type Your Ingredients Here..."
        searchController.searchBar.delegate = self //allows us to use delegate methods of searchbar later on
        searchController.searchBar.sizeToFit()
        
        
        //place searchbar view to the tableview headerview
        recipeSearchTableView.tableHeaderView = searchController.searchBar
        
    }
    
    //Searchbar delegate methods
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        testView.isHidden = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //self.recipeSearchTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        self.recipeSearchTableView.reloadData()
        fetchRecipes(items: items!)
        testView.isHidden = true
        
        //self.recipeSearchTableView.setContentOffset(CGPoint(x: 0, y: 44), animated: true)
        //recipeSearchTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchString = searchController.searchBar.text
        searchItems = searchString?.lowercased().components(separatedBy: " ")
        
        fetchRecipes(items: searchItems!)
        testView.isHidden = true
        //searchController.searchBar.resignFirstResponder()

    }
    

    
    func updateSearchResults(for searchController: UISearchController) {
//        let searchString = searchController.searchBar.text
//        searchItems = searchString?.components(separatedBy: " ")
        
        
        //perform search using Yummly API
        
        //recipeSearchTableView.reloadData()
    }
    
    
    private func fetchRecipes(items: [String]){
        
        var itemString = ""
        
        for i in items{
            itemString = itemString + "allowedIngredient[]=\(i)&"
        }
        
        //let recipeURL: String = "http://api.yummly.com/v1/api/recipes?_app_id=040ca89b&_app_key=b52b549137b851a8e6fe14e451c86218&allowedIngredient[]=salmon&maxResult=40"
        
        let recipeURL: String = "http://api.yummly.com/v1/api/recipes?_app_id=040ca89b&_app_key=b52b549137b851a8e6fe14e451c86218&\(itemString)requirePictures=true&maxResult=50"
        print(recipeURL)
        
        let urlRequest = URLRequest(url: URL(string: recipeURL)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest){ (data, response, error) in
            
            if error != nil{
                print(error!)
                return
            }
            
            
            self.recipes = [Recipe]()
            do{
                print("entered")
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject] //gives us json object in form of dictionary of string to anyobject
                
                if let recipesFromJson = json["matches"] as? [[String: AnyObject]]{
                    
                    for recipeFromJson in recipesFromJson{
                        
                        let recipe = Recipe()
                        //extract values we want for each recipe
                        
                        if let title = recipeFromJson["recipeName"] as? String, let dictToImage = recipeFromJson["smallImageUrls"] as? [String], let id = recipeFromJson["id"] as? String{
                            recipe.name = title
                            recipe.imageURL = self.changeImageRes(url: dictToImage[0], size: 360)
                            
                            //need function to extract recipe url
                            //Update: recipe url have same format: http://www.yummly.co/recipe/RECIPE_ID?
                            recipe.recipeURL = "http://www.yummly.co/recipe/\(id)"
                        }
                        
                        //                        if let title = recipeFromJson["recipeName"] as? String, let dictToImage = recipeFromJson["imageUrlsBySize"] as? [String: AnyObject]{
                        //                            recipe.name = title
                        //
                        //
                        //                            if let urlToImage = dictToImage["90"] as? String{
                        //                                recipe.imageURL = urlToImage
                        //                            }
                        //
                        
                        self.recipes?.append(recipe)
                    }
                }//array of dictionary
                print("test2")
                
                DispatchQueue.main.async {
                    self.recipeSearchTableView.reloadData()
                    print("test1")
                }
            }
            catch let error{
                print(error)
            }
        }
        task.resume()
        print("else")
    }
    
    private func changeImageRes(url: String, size: Int) -> String{
        let endIndex = url.index(url.endIndex, offsetBy: -2)
        var truncated = url.substring(to: endIndex)
        truncated = "\(truncated)\(size)"
        return truncated
    }

    
    
    //Tableview delegate methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1{
            return self.recipes?.count ?? 0  //If recipe doesnt exist, use 0 rows
        }
        else{
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? ForYouTableViewCell else {return}
        
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.section == 0){
            let cell = recipeSearchTableView.dequeueReusableCell(withIdentifier: "ForYouSearchCell", for: indexPath) as! ForYouTableViewCell
            return cell
        }
        else{
            let cell = recipeSearchTableView.dequeueReusableCell(withIdentifier: "RecipeSearchCell", for: indexPath) as! RecipeTableViewCell
            
            cell.recipeName.text = self.recipes?[indexPath.item].name
            cell.imgView.downloadImage(from: (self.recipes?[indexPath.item].imageURL!)!)
            
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = recipeSearchTableView.dequeueReusableCell(withIdentifier: "headerSearchCell") as! HeaderTableViewCell
        
        cell.sectionHeader.text = sections[section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    

  

}


extension SearchViewController:  UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForYouCell", for: indexPath) as! ForYouCollectionViewCell
        //cell.recipeImage.image = images[indexPath.item % images.count]
        cell.recipeImage.image = images[indexPath.item]
        return cell
    }
}
