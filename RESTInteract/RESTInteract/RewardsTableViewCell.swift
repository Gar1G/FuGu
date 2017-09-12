//
//  RewardsTableViewCell.swift
//  RESTInteract
//
//  Created by Akshay  on 10/06/2017.
//  Copyright © 2017 Akshay . All rights reserved.
//

import UIKit

class RewardsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var rewardCollectionView: UICollectionView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension RewardsTableViewCell{
    
    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDataSource & UICollectionViewDelegate>
        (dataSourceDelegate: D, forRow row: Int) {
        
        //let leftAndRightPaddings: CGFloat = 0
        let height : CGFloat = 100
        let width: CGFloat = 100
        
        rewardCollectionView.delegate = dataSourceDelegate
        rewardCollectionView.dataSource = dataSourceDelegate
        rewardCollectionView.tag = row
        
        //let width = rewardCollectionView.frame.width - leftAndRightPaddings
        let layout = rewardCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumInteritemSpacing = 10
        rewardCollectionView.backgroundColor = UIColor.white
        
        rewardCollectionView.reloadData()
    }
}
