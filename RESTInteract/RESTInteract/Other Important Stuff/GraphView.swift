//
//  GraphView.swift
//  RESTInteract
//
//  Created by Akshay  on 19/05/2017.
//  Copyright © 2017 Akshay . All rights reserved.
//

import UIKit

//@IBDesignable
class GraphView: UIView {
    
    var graphPoints:[Int] = [20, 100, 200, 10, 50, 300, 100]
    //var graphPoints: [Int] = [20,100, 20, 50]
    //var graphPoints: [Int] = []

    //set up start and end colours for the gradient
    @IBInspectable var startColour: UIColor = UIColor.red
    @IBInspectable var endColour: UIColor = UIColor.green
    
    override func draw(_ rect: CGRect) {
        
        let width = rect.width
        let height = rect.height
        
        //set background clipping area, ie rounded corners
        var path = UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: 8.0, height: 8.0))
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
        
        //calculate x point in closure form
        let margin:CGFloat = 20.0
        //takes a column as a parameter an returns value where point should be on x axis
        var columnXPoint = { (column:Int) -> CGFloat in
            //calculate gap between points
            let spacer = (width - margin*2 - 4)/CGFloat((self.graphPoints.count - 1))
            var x:CGFloat = CGFloat(column) * spacer
            x += margin + 2
            return x
        }
        //x axis now consists of 7 equally spaced points
        
        //calculate y point
        
        let topBorder:CGFloat = 60
        let bottomBorder:CGFloat = 50
        let graphHeight = height - topBorder - bottomBorder
        let maxVal = graphPoints.max()
        //takes value from array of sample points and returns y position between 0 and max value
        var ColumnYPoint = { (graphPoint:Int) -> CGFloat in
            var y:CGFloat = CGFloat(graphPoint)/CGFloat(maxVal!)*graphHeight
            y = graphHeight + topBorder - y //flips the graph
            return y
        }
        //origin of view is actually top left, but graph origin is bottom left therefore must flip
        
        //line drawing code
        UIColor.white.setFill()
        UIColor.white.setStroke()
        
        //set up points line
        var graphPath = UIBezierPath()
        //go to start of line
        graphPath.move(to: CGPoint(x: columnXPoint(0), y: ColumnYPoint(graphPoints[0])))
        
        //add points for each item in the graph points array at correct (x,y)
        for i in 1..<graphPoints.count{
            let nextPoint = CGPoint(x: columnXPoint(i), y: ColumnYPoint(graphPoints[i]))
            graphPath.addLine(to: nextPoint)
        }
        
        //graphPath.stroke() //for testing purposes
        
        
        //Creation of gradient underneath path
        //using clipping path
        
        //pushes a copy of current graphics state onto state stack
        //can make changes to context properties
        context?.saveGState()
        
        //make copy of path
        var clippingPath = graphPath.copy() as! UIBezierPath
        
        //add lines to the copied path to complete the clip area
        clippingPath.addLine(to: CGPoint(x: columnXPoint(graphPoints.count - 1), y: height))
        clippingPath.addLine(to: CGPoint(x: columnXPoint(0), y: height))
        clippingPath.close()
        
        //add clipping path to context
        clippingPath.addClip()
        
        //temp code - check clipping path
        let highestYPoint = ColumnYPoint(maxVal!)
        startPoint = CGPoint(x: margin, y: highestYPoint)
        endPoint = CGPoint(x: margin, y: self.bounds.height)
        
        //original state taken off stack and context properties revert
        
        
        //find highest value in data and use as starting point for gradient
        context?.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
        context?.restoreGState()
        
        graphPath.lineWidth = 2.0
        graphPath.stroke()
        
        for i in 0..<graphPoints.count{
            var point = CGPoint(x: columnXPoint(i), y: ColumnYPoint(graphPoints[i]))
            point.x -= 5.0/2
            point.y -= 5.0/2
            
            let circle = UIBezierPath(ovalIn: CGRect(origin: point, size: CGSize(width: 5.0, height: 5.0)))
            circle.fill()
        }
        
        
        //Add horizontal graph lines
        
        var linePath = UIBezierPath()
        
        //top line
        linePath.move(to: CGPoint(x: margin, y: topBorder))
        linePath.addLine(to: CGPoint(x: width - margin, y: topBorder))
        
        //center line
        linePath.move(to: CGPoint(x: margin, y: graphHeight/2 + topBorder))
        linePath.addLine(to: CGPoint(x: width - margin, y: graphHeight/2 + topBorder))
        
        //bottom line
        linePath.move(to: CGPoint(x: margin, y: height - bottomBorder))
        linePath.addLine(to: CGPoint(x: width - margin, y: height - bottomBorder))
        
        let color  = UIColor(white: 1.0, alpha: 0.3)
        color.setStroke()
        linePath.lineWidth = 1.0
        linePath.stroke()

    }

}
