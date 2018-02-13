//
//  GradientView.swift
//  RESTInteract
//
//  Created by Akshay  on 16/06/2017.
//  Copyright © 2017 Akshay . All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    //set up start and end colours for the gradient
    @IBInspectable var startColour: UIColor = UIColor.red
    @IBInspectable var endColour: UIColor = UIColor.green
    
    override func draw(_ rect: CGRect) {
        let width = rect.width
        let height = rect.height
        
        //set background clipping area, ie rounded corners
        //var path = UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: 8.0, height: 8.0))
        var path = UIBezierPath(rect: rect)
        path.addClip() //creates clipping area that constrains gradient
        let context = UIGraphicsGetCurrentContext()
        let colours = [startColour.cgColor, endColour.cgColor]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        //set up colour stops
        let colorLocations: [CGFloat] = [0.0, 1.0]
        
        //create gradient
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colours as CFArray, locations: colorLocations)
        
        //draw gradient
        var startPoint = CGPoint.zero
        var endPoint = CGPoint(x: 0, y: self.bounds.height)
        context?.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
