//
//  WasteDashboardViewController.swift
//  RESTInteract
//
//  Created by Akshay  on 10/06/2017.
//  Copyright © 2017 Akshay . All rights reserved.
//

import UIKit
import CoreData

class WasteDashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate {
    
    //System variables
    let defaults = UserDefaults.standard
    let calendar = Calendar.current
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var rewards: [Int] = []
    let rewardImage: [UIImage] = [#imageLiteral(resourceName: "FuGu_reward1"), #imageLiteral(resourceName: "FuGu_reward2"), #imageLiteral(resourceName: "FuGu_reward3"), #imageLiteral(resourceName: "FuGu_reward4")]
    let rewardImageGreyed: [UIImage] = [#imageLiteral(resourceName: "FuGu_reward1_un"), #imageLiteral(resourceName: "FuGu_reward2_un"), #imageLiteral(resourceName: "FuGu_reward3_un"), #imageLiteral(resourceName: "FuGu_reward4_un")]
    let rewardNames: [String] = ["Set your lowest waste produced in a week", "Set your lowest waste produced in a month", "Reduce your waste for 2 weeks in a row", "The Ultimate Prize!"]
    var progressStatement = String()
    
    @IBOutlet weak var popupBlur: UIVisualEffectView!
    
    var effect: UIVisualEffect!
    
    
    @IBOutlet weak var rewardPopupLabel: UILabel!
    @IBOutlet weak var rewardImagePopup: UIImageView!
    @IBOutlet var rewardPopupView: UIView!
    

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        wasteTableview.reloadData()
    }
    @IBOutlet weak var wasteTableview: UITableView!
    
    var lastWaste = Date()
    var lowestWeekWaste: Int = Int.max
    var lowestMonthWaste: Int = Int.max
    
    //Arrays to pass to Waste data to Graph
//    var weekWasteData : [Waste] = []
//    var monthWasteData: [Waste] = []
//    var yearWasteData: [Waste] = []
//    var allWasteData: [Waste] = []
    
    var weekWasteData : [Int] = [12, 0, 0, 43, 21, 0, 0]
    var monthWasteData : [Int] = [23, 57, 8, 0, 0, 0, 24, 0, 39, 18, 0, 0, 13, 0, 15, 11, 67, 0, 0, 0, 0, 27, 0, 31, 13, 0, 0, 43, 21, 0, 0]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        effect = popupBlur.effect
        popupBlur.effect = nil
        popupBlur.isHidden = true
        rewardPopupView.layer.cornerRadius = 5
        setupStats()
        
        
        //checkLastWaste()
        //function to split the core data up into 3 sets of data
        //weekWasteData = getCoreData(days: 6)
        //monthWasteData = getCoreData(days: 30)
        
        rewardCalculation()
        wasteTableview.allowsSelection = false
        wasteTableview.delegate = self
        wasteTableview.dataSource = self
        wasteTableview.reloadData()
    }
    
    func setupStats(){
        if defaults.object(forKey: "rewards") == nil{
            defaults.set(rewards, forKey: "rewards")
        }
        else{
            rewards = defaults.object(forKey: "rewards") as! [Int]
        }
        if defaults.object(forKey: "lowestWeekWaste") == nil{
            defaults.set(lowestWeekWaste, forKey: "lowestWeekWaste")
        }
        else{
            lowestWeekWaste = defaults.object(forKey: "lowestWeekWaste") as! Int
        }
        if defaults.object(forKey: "lowestMonthWaste") == nil{
            defaults.set(lowestMonthWaste, forKey: "lowestMonthWaste")
        }
        else{
            lowestMonthWaste = defaults.object(forKey: "lowestMonthWaste") as! Int
        }
    }
    
    func getCoreData(days: Int) -> [Waste]{
        let fetchRequest : NSFetchRequest<Waste> = Waste.fetchRequest()
        let entity = NSEntityDescription.entity(forEntityName: "Waste", in: context)
        fetchRequest.entity = entity
        var date = calendar.date(byAdding: .day, value: -(days), to: Date())
        date = calendar.startOfDay(for: date!)
        let predicate = NSPredicate(format: "timestamp > %@", date! as NSDate)
        fetchRequest.predicate = predicate
        
        do{
            let data = try context.fetch(fetchRequest)
            print(data.count)
            return data
        }
        catch{
            print("Fetching Failed")
        }
        
        return [Waste]()

    }
    
    func checkLastWaste(){
        
        //If waste has been retrieved beforehand
        if defaults.object(forKey: "lastWasteDate") != nil{
            //get the last date retrieval was made
            lastWaste = defaults.object(forKey: "lastWasteDate") as! Date
            //call function for get waste data
            //calculate how many days worth of data is missing
            let daysToRetrieve = dateDifference(date: lastWaste)
            
            if(daysToRetrieve <= 0){
                //if last retrieval was made today
                //No further request gets made for today
                //alert no more data
                print("No more data")
                //let alert = UIAlertController(title: "Waste Data is Up-To-Date", message: "Check back tomorrow for more", preferredStyle: UIAlertControllerStyle.alert)
                //alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                //self.present(alert, animated: true, completion: nil)
            }
            else{
                //If last retrieval made before today then can request data
                getWasteData(days: daysToRetrieve)
                //reset last waste date as today
                lastWaste = Date()
                defaults.set(lastWaste, forKey: "lastWasteDate")
                defaults.synchronize()
            }
        }
        else{
            getWasteData(days: 365)
            defaults.set(lastWaste, forKey: "lastWasteDate")
        }
    }
    
    
    func rewardCalculation(){
        let date = Date()
        let component = calendar.dateComponents([.weekday], from: date)
        let weekday = component.weekday
        if (monthWasteData.count >= 15) && (weekday! == 2){
            //let lastWeekSum = weekWasteData.reduce(0) { $0 + ($1.weight ) }
            let lastWeekSum = weekWasteData.reduce(0) { $0 + ($1) }
            if (Int(lastWeekSum) < lowestWeekWaste){
                lowestWeekWaste = Int(lastWeekSum)
                rewards.append(0)
                defaults.set(lowestWeekWaste, forKey: "lowestWeekWaste")
                defaults.set(rewards, forKey: "rewards")
                progressStatement = "Well Done! Last week you achieved a personal best for least waste produced. Keep it up!"
                
            }
            if(monthWasteData.count >= 60){
                //let lastMonthSum = monthWasteData.reduce(0){$0 + ($1.weight)}
                let lastMonthSum = monthWasteData.reduce(0){$0 + $1}
                if(Int(lastMonthSum) < lowestMonthWaste){
                    rewards.append(1)
                    defaults.set(lowestMonthWaste, forKey: "lowestMonthWaste")
                    defaults.set(rewards, forKey: "rewards")
                    progressStatement = "Well Done! Last month you achieved a personal best for least waste produced. Keep it up!"
                }
            }
            defaults.synchronize()
        }
        else{
            progressStatement = "Tip: Try putting items which you might not use anytime soon in the freezer to preserve their shelf life"
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? RewardsTableViewCell else {return}
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
            //First row is Feedback Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "feedbackCell", for: indexPath) as! WasteFeedbackTableViewCell
            cell.YourProgress.text = "Your Progress"
            //cell.feedbackLabel.text = "Well Done! Last week you achieved a personal best for least waste produced. Keep it up!"
            cell.feedbackLabel.text = progressStatement
            
            return cell
        }
        else if (indexPath.row == 1){
            //second row is graph
            let cell = tableView.dequeueReusableCell(withIdentifier: "graphCell", for: indexPath) as! WasteGraphTableViewCell
            cell.setupGraphDisplay(type: segmentedControl.selectedSegmentIndex, weekdata: weekWasteData, monthdata: monthWasteData)
            //cell.setupGraphDisplay()
            return cell
            
        }
        else{
            //3rd row is Rewards Collection view
            let cell = tableView.dequeueReusableCell(withIdentifier: "rewardCell", for: indexPath) as! RewardsTableViewCell
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 1){
            return 240.0
        }
        else{
            return 130
        }
    }
    
    
    func dateDifference(date: Date) -> Int{
        
        let date1:Date = calendar.startOfDay(for: Date())
        let date2:Date = calendar.startOfDay(for: date)
        let components = calendar.dateComponents([.day], from: date2, to: date1)
        
        return (components.day!)
        
    }
    
    
    func getWasteData(days: Int){
        let semaphore = DispatchSemaphore(value: 0)
        let id = defaults.value(forKey: "UserID") as! Int
        let wasteURL: String = "https://foodappee.azurewebsites.net/getWaste?id=\(id)&days=\(days)"
        
        var urlRequest = URLRequest(url: URL(string: wasteURL)!)
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: urlRequest){ (data, response, error) in
            print("something")
            if error != nil{
                print(error!)
                return
            }
            do{
                print("Something2")
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [[String: AnyObject]] //gives us json object in form of dictionary of string to anyobject
                
                if !json.isEmpty{
                    for wasteEntry in json{
                        if let time = wasteEntry["Timestamp"] as? String, let weight = wasteEntry["Weight"] as? Int16{
                            
                            let entity = NSEntityDescription.entity(forEntityName: "Waste", in: self.context)
                            let waste = NSManagedObject(entity: entity!, insertInto: self.context)
                            waste.setValue(weight, forKey: "weight")
                            
                            let wasteTimestamp = self.stringToDate(date: time)
                            waste.setValue(wasteTimestamp, forKey: "timestamp")
                            print("item found")
                            do{
                                try self.context.save()
                                
                                print("save success")
                            }
                            catch let error as NSError{
                                print("Could not save \(error), \(error.userInfo)")
                            }
                            
                            print("success")
                            
                        }
                    }
                }
                semaphore.signal()
                
                DispatchQueue.main.async {
                    self.wasteTableview.reloadData()
                }

            }
            catch let error{
                print(error)
            }
            
        }
        task.resume()
        //Waits for URL task to complete
        semaphore.wait()

    }
    
    func stringToDate(date: String) -> Date{
        
        let dateFor = DateFormatter()
        dateFor.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFor.date(from: date)!
    }
    
    func animateIn(image: UIImage, label: String){
        self.view.addSubview(rewardPopupView)
        rewardPopupView.center = self.view.center
        rewardImagePopup.image = image
        rewardPopupLabel.text = label
        popupBlur.isHidden = false
        rewardPopupView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        rewardPopupView.alpha = 0
        UIView.animate(withDuration: 0.3){
            self.popupBlur.effect = self.effect
            self.rewardPopupView.alpha = 1
            self.rewardPopupView.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.rewardPopupView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.rewardPopupView.alpha = 0
            self.popupBlur.effect = nil
            self.popupBlur.isHidden = true
            
        }) { (success: Bool) in
            self.rewardPopupView.removeFromSuperview()
            
        }
    }
    
    

    @IBAction func dismissPopup(_ sender: UIButton) {
        animateOut()
    }
    
    
    
    
//    func postWaste(){
//        var str = "2017-06-09T18:41:00Z"
//        
//        var dateFor: DateFormatter = DateFormatter()
//        
//        dateFor.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//        
//        var yourDate: Date? = dateFor.date(from: str)
//        
//        print(yourDate!)
//        //let id = defaults.value(forKey: "UserID") as! Int
//        
//        let json: [String: Any] = ["UserId": 8,
//                                   "Timestamp": str,
//                                   "Weight": 20]
//        
//        
//        let jsonData = try? JSONSerialization.data(withJSONObject: json)
//        
//        // create post request
//        let url = URL(string: "https://foodappee.azurewebsites.net/postWaste")!
//        var request = URLRequest(url: url)
//        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
//        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
//        request.httpMethod = "POST"
//        
//        // insert json data to the request
//        request.httpBody = jsonData
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                print(error?.localizedDescription ?? "No data")
//                return
//            }
//            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
//            print("something")
//            if let responseJSON = responseJSON as? [String: Any] {
//                print(responseJSON)
//            }
//        }
//        task.resume()
//        
//    }


    
}


extension WasteDashboardViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rewardImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RewardCollectionCell", for: indexPath) as! RewardCollectionViewCell
        if rewards.contains(indexPath.item){
            cell.rewardImage.image = rewardImage[indexPath.item]
        }
        else{
            cell.rewardImage.image = rewardImageGreyed[indexPath.item]
        }
        if(indexPath.item == 0){
            cell.rewardImage.image = rewardImage[indexPath.item]
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.item)")
        animateIn(image: rewardImage[indexPath.item], label: rewardNames[indexPath.item])
        
        
        
    }
    
    
}
