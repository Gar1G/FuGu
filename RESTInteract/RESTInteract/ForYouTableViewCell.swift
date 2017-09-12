//
//  ForYouTableViewCell.swift
//  RESTInteract
//
//  Created by Akshay  on 18/05/2017.
//  Copyright © 2017 Akshay . All rights reserved.
//

import UIKit

class ForYouTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //@IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension ForYouTableViewCell{
    
    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDataSource & UICollectionViewDelegate>
        (dataSourceDelegate: D, forRow row: Int) {
        
        let leftAndRightPaddings: CGFloat = 0
        let height : CGFloat = 180.0
        
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        
        let width = collectionView.frame.width - leftAndRightPaddings
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumInteritemSpacing = 0
        collectionView.backgroundColor = UIColor.white
        //collectionView.addcon
        
        collectionView.reloadData()
    }
}
