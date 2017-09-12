//
//  WasteGraphTableViewCell.swift
//  RESTInteract
//
//  Created by Akshay  on 10/06/2017.
//  Copyright © 2017 Akshay . All rights reserved.
//

import UIKit

class WasteGraphTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var graphView: GraphView!
    
    
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var avgWasteProduced: UILabel!
    
    func setupGraphDisplay(type: Int, weekdata: [Int], monthdata: [Int]){
        
        
        var w : [Int] = []
        var m : [Int] = []
        
        
        for i in weekdata{
            //w.append(i.value(forKey: "weight") as! Int)
            w.append(i)
        }
        for j in monthdata{
            //m.append(j.value(forKey: "weight") as! Int)
            m.append(j)
        }
        

        let calendar = NSCalendar.current
        
        
        //day of the week labels set up in storyboard with tags
        //today is last day of the array, need to go backwards
        
        //get todays day number
        
        
        if (type == 0){
            //week view
            self.graphView.graphPoints = w
            //let dateFormatter = DateFormatter()
            let componentOptions: Calendar.Component = .weekday
            let components = calendar.dateComponents([componentOptions], from: Date())
            var weekday = components.weekday
            
            let days = ["S", "S", "M", "T", "W", "T", "F"]
            
            //set up day name labels with correct day
            for i in stride(from: days.count, to: 0, by: -1){
                if let labelView = graphView.viewWithTag(i) as? UILabel{
                    if weekday == 7{
                        weekday = 0
                    }
                    labelView.isHidden = false
                    labelView.text = days[weekday!]
                    labelView.font = labelView.font.withSize(17)
                    weekday = weekday! - 1
                    if weekday! < 0 {
                        weekday = days.count - 1
                    }
                }
            }

        }
        else if(type == 1){
            //month view
            self.graphView.graphPoints = m
            let today = Date()
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: today)
            let halfMonthAgo = calendar.date(byAdding: .day, value: 15, to: monthAgo!)
            
            
            //var month_dates = [monthAgo!, halfMonthAgo!, today]
            
            var month_dates_string = [dateTruncate(date: monthAgo!), dateTruncate(date: halfMonthAgo!), dateTruncate(date: today)]
            
            for i in 1...7{
                if let labelView = graphView.viewWithTag(i) as? UILabel{
                    if(i==1){
                        labelView.text = month_dates_string[0]
                        labelView.font = labelView.font.withSize(12)
                    }
                    else if(i == 4){
                        labelView.text = month_dates_string[1]
                        labelView.font = labelView.font.withSize(12)
                    }
                    else if(i==7){
                        labelView.text = month_dates_string[2]
                        labelView.font = labelView.font.withSize(12)
                    }
                    else{
                        labelView.isHidden = true
                    }
                }
            }

        }
        else{
            //year view
        }
        
        maxLabel.text = "\(graphView.graphPoints.max()!)"
        let average = graphView.graphPoints.reduce(0, { x,y in
            x + y
            
        })/graphView.graphPoints.count
        avgWasteProduced.text = "\(average)g"
        
        //set up labels
        
        self.graphView.setNeedsDisplay()

        
    }
    
    func dateTruncate(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let t = dateFormatter.string(from: date)
        let endIndex = t.index(t.endIndex, offsetBy: -6)
        let truncated = t.substring(to: endIndex)
        return truncated
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        //setupGraphDisplay(type: 7, data: [20, 100])
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
