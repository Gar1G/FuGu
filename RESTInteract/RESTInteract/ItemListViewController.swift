//
//  ItemListViewController.swift
//  RESTInteract
//
//  Created by Akshay  on 30/04/2017.
//  Copyright © 2017 Akshay . All rights reserved.
//

import UIKit
import CoreData

class ItemListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var itemTableView: UITableView!
    let defaults = UserDefaults.standard
    public var items: [itemFood]? = []
    private let refreshControl = UIRefreshControl()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let calendar = Calendar.current
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
        //fetchItems()
        
        itemTableView.dataSource = self
        itemTableView.delegate = self
        itemTableView.allowsSelection = false
        
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        //fetchItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupRefreshControl(){
        refreshControl.addTarget(self, action: #selector(ItemListViewController.handleRefresh(refreshControl:)), for: .valueChanged)
        self.itemTableView.refreshControl = refreshControl
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        // Simply adding an object to the data source for this example
        //fetchItems()
        self.itemTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.items?.count ?? 0
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = itemTableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell
        /*
        cell.itemName.text = self.items?[indexPath.item].name
        let date2:Date = calendar.startOfDay(for: (self.items?[indexPath.item].expiry)!)
        let date1:Date = calendar.startOfDay(for: Date())
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        if(components.day! < 0){
            cell.daysLabel.text = "EXPIRED"
            
        }
        else{
            cell.daysLabel.text = "\(components.day!)"
        }
        
        cell.daysUntilExpiry.text = "Days Until Expiry:"
        
        let priority = self.items?[indexPath.item].priority
        
        if priority == 1{
            cell.foodTypeImage.image = #imageLiteral(resourceName: "FuGU_item_icon1")
        }
        else if priority == 2{
            cell.foodTypeImage.image = #imageLiteral(resourceName: "FuGU_item_icon2")
        }
        else if priority == 3{
            cell.foodTypeImage.image = #imageLiteral(resourceName: "FuGU_item_icon3")
        }
        else{
            cell.foodTypeImage.image = #imageLiteral(resourceName: "FuGU_item_icon4")
        }
        */
        
        // Dummy Food items
        cell.daysUntilExpiry.text = "Days Until Expiry:"
        if indexPath.row == 0{
            //first item
            cell.itemName.text = "Chicken Fillets"
            cell.daysLabel.text = "2"
            cell.foodTypeImage.image = #imageLiteral(resourceName: "FuGU_item_icon1")
        }
        else if indexPath.row == 1{
            //second item
            cell.itemName.text = "Brocolli"
            cell.daysLabel.text = "2"
            cell.foodTypeImage.image = #imageLiteral(resourceName: "FuGU_item_icon2")
        }
        else if indexPath.row == 2{
            //third item
            cell.itemName.text = "Bread"
            cell.daysLabel.text = "3"
            cell.foodTypeImage.image = #imageLiteral(resourceName: "FuGU_item_icon4")
        }
        else{
            //fourth Item
            cell.itemName.text = "Milk"
            cell.daysLabel.text = "5"
            cell.foodTypeImage.image = #imageLiteral(resourceName: "FuGU_item_icon3")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Item Selected")
    }
    
    func fetchItems(){
        //let id = defaults.value(forKey: "UserId") as Int
        //let id = 8
        let id = defaults.value(forKey: "UserID") as! Int
        
        let getItemURL: String = "https://foodappee.azurewebsites.net/GetItems?id=\(id)"
        
        let urlRequest = URLRequest(url: URL(string: getItemURL)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest){ (data, response, error) in
            
            if error != nil{
                print(error!)
                return
            }
            self.items = [itemFood]()
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
                            
                            self.items?.append(item)
                            
                        }
                        
                    }
                    self.items?.sort(by: {$0.expiry! < $1.expiry!})
                    
                }
                DispatchQueue.main.async {
                    if(self.items?.count == 0){
                        let alert = UIAlertController(title: "No Items Found", message: "No items were detected in your fridge.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        alert.view.tintColor = UIColor(red: 1.0, green: 0, blue: 0.3, alpha: 1.0)
                        self.present(alert, animated: true, completion: nil)
                    }

                    self.itemTableView.reloadData()
                }
                
                
            }
            catch let error{
                print(error)
            }
        }
        task.resume()
    }
    
    

}
