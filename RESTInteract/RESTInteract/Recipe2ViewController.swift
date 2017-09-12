//
//  Recipe2ViewController.swift
//  RESTInteract
//
//  Created by Akshay  on 18/05/2017.
//  Copyright © 2017 Akshay . All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class Recipe2ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    

    //var delegate: DownloadSessionDelegate

    
    var recipes: [Recipe]? = []
    var yourRecipes: [UserRecipe] = []
    private let refreshControl = UIRefreshControl()
    var cuisinesPresets: [String] = ["american", "asian", "barbecue", "cajun&creole", "chinese", "cuban", "english", "french", "german", "greek", "hungarian", "indian", "irish", "italian", "japanese", "meditterranean", "mexican", "moroccan", "portugese", "southern&soul","spanish", "swedish", "thai"]
    var cuisineChoices: [String]? = []
    var items: [String] = ["chicken", "brocolli"]
    let defaults = UserDefaults.standard
    
    let sections: [String] = ["Your Recipes", "Recipes By Yummly"]
    var searchController: UISearchController!
    var searchItems: [String]? = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    
    @IBOutlet weak var recipeTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeNotification()
        setupRefreshControl()
        //fetchItems()
        configureSearchController()
        retrieveCuisines()
        fetchRecipes(items: items, cuisines: cuisineChoices!)
        fetchUserRecipes(items: items)
        recipeTableView.dataSource = self
        recipeTableView.delegate = self
        print(items)
        // Do any additional setup after loading the view.
    }
    
    
    func setupRefreshControl(){
        refreshControl.addTarget(self, action: #selector(Recipe2ViewController.handleRefresh(refreshControl:)), for: .valueChanged)
        self.recipeTableView.refreshControl = refreshControl
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        // Simply adding an object to the data source for this example
        print("refresh")
        retrieveCuisines()
        //fetchItems()
        fetchRecipes(items: items, cuisines: cuisineChoices!)
        fetchUserRecipes(items: items)
        self.recipeTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    // SEARCH RELATED FUNCTIONS
    func configureSearchController(){
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Type Your Ingredients Here..."
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        //searchController.searchBar.barTintColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        searchController.searchBar.tintColor = UIColor(red: 1.0, green: 0, blue: 0.3, alpha: 1.0)
        recipeTableView.tableHeaderView = searchController.searchBar
        
    }
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.recipeTableView.reloadData()
        fetchRecipes(items: items, cuisines: cuisineChoices!)
        fetchUserRecipes(items: items)
        //view hidden
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchString = searchController.searchBar.text
        searchItems = searchString?.lowercased().components(separatedBy: " ")
        fetchRecipes(items: searchItems!, cuisines: cuisineChoices!)
        fetchUserRecipes(items: searchItems!)
        //view hidden
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //view not hidden, overlays on top of tableview whilst typing search
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // REQUIRED TABLEVIEW DELEGATE FUNCTIONS
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
            let cell = recipeTableView.dequeueReusableCell(withIdentifier: "ForYouCell", for: indexPath) as! ForYouTableViewCell
            return cell
        }
        else{
            let cell = recipeTableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeTableViewCell

            cell.recipeName.text = self.recipes?[indexPath.item].name
            cell.sourceName.text = self.recipes?[indexPath.item].source
            cell.imgView.downloadImage(from: (self.recipes?[indexPath.item].imageURL!)!)
            
            return cell
        }
    }
    
    // TABLEVIEW HEADER FUNCTIONS
    //Only functions correctly when heightForHeaderInSection implemented
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = recipeTableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderTableViewCell
        
        cell.sectionHeader.text = sections[section]
        
        //If header not for Your Recipes
        if(section == 1){
            cell.seeMoreButton.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0){
            return 180
        }
        else{
            return 230.0
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRecipeSegue", let destination = segue.destination as? RecipeWebViewController, let recipeIndex = recipeTableView.indexPathForSelectedRow?.row{
            destination.urlString = (recipes?[recipeIndex].recipeURL!)!
            destination.recipeName = (recipes?[recipeIndex].name)!
        }
    }
    
    func retrieveCuisines(){
        if defaults.object(forKey: "CuisinePreferences") != nil{
            let prefs = defaults.object(forKey: "CuisinePreferences") as! [Int]
            for i in 0...(cuisinesPresets.count-1){
                if prefs.contains(i){
                    cuisineChoices?.append(cuisinesPresets[i])
                }
            }
        }
    }
    
    
    
    // YUMMLY RECIPE SEARCH
    func fetchRecipes(items: [String], cuisines: [String]){
        
        var itemString = ""
        var cuisineString=""
        for i in items{
            itemString = itemString + "allowedIngredient[]=\(i)&"
        }
        for i in cuisines{
            cuisineString = cuisineString + "allowedCuisine[]=cuisine^cuisine-\(i)&"
        }
        
        //let recipeURL: String = "http://api.yummly.com/v1/api/recipes?_app_id=040ca89b&_app_key=b52b549137b851a8e6fe14e451c86218&allowedIngredient[]=salmon&maxResult=40"
        
        let recipeURL: String = "https://api.yummly.com/v1/api/recipes?_app_id=040ca89b&_app_key=b52b549137b851a8e6fe14e451c86218&\(itemString)\(cuisineString)requirePictures=true&maxResult=100"
        print(recipeURL)
        
        let urlRequest = URLRequest(url: URL(string: recipeURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!)
        
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
                        
                        if let title = recipeFromJson["recipeName"] as? String, let dictToImage = recipeFromJson["smallImageUrls"] as? [String], let id = recipeFromJson["id"] as? String, let src = recipeFromJson["sourceDisplayName"] as? String{
                            recipe.name = title
                            recipe.source = src
                            recipe.imageURL = self.changeImageRes(url: dictToImage[0], size: 360)
                            
                            //need function to extract recipe url
                            //Update: recipe url have same format: http://www.yummly.co/recipe/RECIPE_ID?
                            recipe.recipeURL = "http://www.yummly.co/recipe/\(id)"
                            
                            self.recipes?.append(recipe)
                        }
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
    
    private func fetchUserRecipes(items: [String]){
        do{
            let allRecipes = try context.fetch(UserRecipe.fetchRequest()) as [UserRecipe]
            self.yourRecipes = [UserRecipe]()
            for f in allRecipes{
                if (f.ingredients?.lowercased().findOccurrencesOf(items: items))!{
                    self.yourRecipes.append(f)
                }
            }
        }
        catch{
            print("Fetching Failed")
        }
    }
    
    func fetchItems(){
        //let config = URLSessionConfiguration.background(withIdentifier: "backgroundFetch")
        //let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
        let semaphore = DispatchSemaphore(value: 0)
        //let id = 8
        let id = defaults.value(forKey: "UserID") as! Int
        
        let getItemURL: String = "https://foodappee.azurewebsites.net/GetItems?id=\(id)"
        
        let urlRequest = URLRequest(url: URL(string: getItemURL)!)
//        let task = URLSession.shared.dataTask(with: urlRequest){ (data, response, error) in
        
        let task = URLSession.shared.dataTask(with: urlRequest){ (data, response, error) in
            
            if error != nil{
                print(error!)
                return
            }
            var allItems = [itemFood]()
            //self.items = [itemFood]()
            do{
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject] //gives us json object in form of dictionary of string to anyobject
                if let itemsFromJson = json["FoodItems"] as? [[String: AnyObject]]{
                    for itemFromJson in itemsFromJson{
                        //let item = FoodItem()
                        //let entity = NSEntityDescription.entity(forEntityName: "FoodItem", in: context)!
                        //let item = NSManagedObject(entity: entity, insertInto: context)
                        //let item = FoodItem(context: self.context)
                        let item = itemFood()
                        if let name = itemFromJson["ProductName"] as? String, let weight = itemFromJson["Weight"] as? Int, let price = itemFromJson["Price"] as? Double, let expiry = itemFromJson["Expiry"] as? String, let purchased = itemFromJson["Purchased"] as? String, let priority = itemFromJson["Priority"] as? Int16, let id = itemFromJson["ProductId"] as? Int32{
                            
                            item.name = name
                            item.productID = id
                            item.priority = priority
                            item.price = price
                            item.weight = Int16(weight)
                            item.expiry = expiry.stringToDate()
                            print(item.expiry!)
                            item.purchased = purchased.stringToDate()
                            
                            allItems.append(item)
                        }
                    }
                    
                }
                
                allItems.sort(by: {$0.expiry! < $1.expiry!})
                var bool1 = false
                var bool2 = false
                for i in allItems{
                    if (i.priority == 1 && !bool1){
                        self.items.append(i.name!.lowercased())
                        bool1 = true
                    }
                    else if (i.priority == 2 && !bool2){
                        self.items.append(i.name!.lowercased())
                        bool2 = true
                    }
                    else{
                        
                    }
                }
                
                semaphore.signal()
                
            }
            catch let error{
                print(error)
            }
        }
        task.resume()
        semaphore.wait()
    }
    
    private func changeImageRes(url: String, size: Int) -> String{
        let endIndex = url.index(url.endIndex, offsetBy: -2)
        var truncated = url.substring(to: endIndex)
        truncated = "\(truncated)\(size)"
        return truncated
    }
    
    func recipeNotification(){
        let content = UNMutableNotificationContent()
        content.body = "Not sure what to cook? Check out tasty recipes tailored just for you!"
        content.categoryIdentifier = "recipeReminder"
        content.sound = UNNotificationSound.default()
        var dateComponents = DateComponents()
        dateComponents.hour = 18
        dateComponents.minute = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        print(dateComponents)
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        let request = UNNotificationRequest(identifier: "recipeNotification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        //let center = UNUserNotificationCenter.current()
        //center.add(request) { (error) in
//            print(error)
//        }
        //UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        print("notification triggered")
    }

}

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView{
    func downloadImage(from url: String){
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        if let imageFromCache = imageCache.object(forKey: url as NSString){
            self.image  = imageFromCache
            return
        }
        let task = URLSession.shared.dataTask(with: urlRequest){ (data, response, error) in
            
            if error != nil{
                print(error!)
                return
            }
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: data!)
                imageCache.setObject(imageToCache!, forKey: url as NSString)
                self.image = imageToCache
            }
        }
        task.resume() // fires task
        
    }
}


// COLLECTIONVIEW DELEGATE FUNCTIONS
extension Recipe2ViewController:  UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(yourRecipes.count == 0){
            return 1
        }
        else{
            return yourRecipes.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForYouCollCell", for: indexPath) as! ForYouCollectionViewCell
        if(yourRecipes.count == 0){
            //display default image in 1 cell
            cell.recipeImage.image = #imageLiteral(resourceName: "FuGU_placeholder")
            cell.yourRecipeName.text = " "
        }
        else{
            let data = yourRecipes[indexPath.item].image
            cell.recipeImage.image = UIImage(data: (data!) as Data)
            cell.yourRecipeName.text = yourRecipes[indexPath.item].name

        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if yourRecipes.count == 0{
            performSegue(withIdentifier: "yourRecipesSegue", sender: self)
            //segue to your recipes page
        }
    }
}



//extension Recipe2ViewController: URLSessionDownloadDelegate{
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
//        
//        print("session \(session) has finished download task \(downloadTask) of URL \(location)")
//    }
//    
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
//        print("session \(session) download task \(downloadTask) wrote an additional \(bytesWritten) out of an expected \(totalBytesWritten)")
//        
//    }
//    
//    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
//        print("background session \(session) finished events.")
//    }
//}


extension String{
    func findOccurrencesOf(items: [String]) -> Bool {
        for item in items {
            if self.range(of: item) == nil {
                return false
            }
        }
        return true
    }
    
    func stringToDate() -> Date{
        let dateFor = DateFormatter()
        dateFor.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFor.date(from: self)!
    }
}


