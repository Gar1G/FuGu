//
//  PreferencesViewController.swift
//  RESTInteract
//
//  Created by Akshay  on 25/05/2017.
//  Copyright © 2017 Akshay . All rights reserved.
//

import UIKit

class PreferencesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //data source
    var cuisines: [String] = ["American", "Asian", "Barbecue", "Cajun & Creole", "Chinese", "Cuban", "English", "French", "German", "Greek", "Hungarian", "Indian", "Irish", "Italian", "Japanese", "Meditterranean", "Mexican", "Moroccan", "Portugese", "Southern & Soul","Spanish", "Swedish", "Thai"]
    let checkedImages: [UIImage] = [#imageLiteral(resourceName: "american"), #imageLiteral(resourceName: "asian"), #imageLiteral(resourceName: "bbq"), #imageLiteral(resourceName: "cajun"), #imageLiteral(resourceName: "chinese"), #imageLiteral(resourceName: "cuban"), #imageLiteral(resourceName: "english"), #imageLiteral(resourceName: "french"), #imageLiteral(resourceName: "german"), #imageLiteral(resourceName: "greek"), #imageLiteral(resourceName: "hungarian"), #imageLiteral(resourceName: "indian"), #imageLiteral(resourceName: "irish"), #imageLiteral(resourceName: "italian"), #imageLiteral(resourceName: "japanese"), #imageLiteral(resourceName: "medit"), #imageLiteral(resourceName: "mexican"), #imageLiteral(resourceName: "moroccan_un"), #imageLiteral(resourceName: "portugese"), #imageLiteral(resourceName: "southern"), #imageLiteral(resourceName: "spanish"), #imageLiteral(resourceName: "swedish"), #imageLiteral(resourceName: "thai")]
    
    let uncheckedImages: [UIImage] = [#imageLiteral(resourceName: "american_un"), #imageLiteral(resourceName: "asian_un"), #imageLiteral(resourceName: "bbq_un"), #imageLiteral(resourceName: "cajun_un"), #imageLiteral(resourceName: "chinese_un"), #imageLiteral(resourceName: "cuban_un"), #imageLiteral(resourceName: "english_un"), #imageLiteral(resourceName: "french_un"), #imageLiteral(resourceName: "german_un"), #imageLiteral(resourceName: "greek_un"), #imageLiteral(resourceName: "hungarian_un"), #imageLiteral(resourceName: "indian_un"), #imageLiteral(resourceName: "irish_un"), #imageLiteral(resourceName: "italian_un"), #imageLiteral(resourceName: "japanese_un"), #imageLiteral(resourceName: "medit_un"), #imageLiteral(resourceName: "mexican_un"), #imageLiteral(resourceName: "moroccan"), #imageLiteral(resourceName: "portugese_un"), #imageLiteral(resourceName: "southern_un"), #imageLiteral(resourceName: "spanish_un"), #imageLiteral(resourceName: "swedish_un"), #imageLiteral(resourceName: "thai_un")]
    //Keeps track of cuisine preferences
    var prefs = [Int]()
    let defaults = UserDefaults.standard
    var done:Bool = false
    

    private let leftAndRightPaddings: CGFloat = 32.0
    private let numberOfItemsPerRow: CGFloat = 3.0
    private let heightAdjustment: CGFloat = 30.0
    
    
    
    
    @IBOutlet weak var preferencesCollectionView: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = (preferencesCollectionView!.frame.width - leftAndRightPaddings)/numberOfItemsPerRow
        let layout = preferencesCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width+heightAdjustment)
        
        preferencesCollectionView.delegate = self
        preferencesCollectionView.dataSource = self
        

        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        if defaults.object(forKey: "CuisinePreferences") != nil{
            prefs = defaults.object(forKey: "CuisinePreferences") as! [Int]
        }
        else{
            defaults.set(prefs, forKey: "CuisinePreferences")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func finishedPreferences(_ sender: UIBarButtonItem) {
        defaults.set(prefs, forKey: "CuisinePreferences")
        defaults.synchronize()
        if(done){
            //ie. if user is updating their preferences they return back to "settings page"
            //self.performSegue(withIdentifier: "finishedSettingsSegue", sender: self)
            dismiss(animated: true, completion: nil)
        }
        else{
            self.performSegue(withIdentifier: "registrationComplete", sender: self)
            //User has entered preferences for the first time, they will be directed to main screen
        }
        
        
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cuisines.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cuisineCell", for: indexPath) as! CuisineCollectionViewCell
        
        cell.cuisineLabel.text = cuisines[indexPath.item]
        if prefs.contains(indexPath.item){
            cell.cuisineImage.image = checkedImages[indexPath.item]
        }
        else{
            cell.cuisineImage.image = uncheckedImages[indexPath.item]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if prefs.contains(indexPath.item){
            let index = prefs.index(of: indexPath.item)
            prefs.remove(at: index!)
            preferencesCollectionView.reloadItems(at: [indexPath])
        }
        else{
            prefs.append(indexPath.item)
            preferencesCollectionView.reloadItems(at: [indexPath])
        }
        print(prefs)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "settingsSegue"{
//            done = true
//        }
//        else{
//            //go to main tab
//            done = false
//        }
//        
//    }
    


}
