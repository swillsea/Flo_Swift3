//
//  ViewController.swift
//  Flo
//
//  Created by Caroline Begbie on 15/04/2015.
//  Copyright (c) 2015 Caroline Begbie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var medalView: MedalView!
    
    //Label outlets
    @IBOutlet weak var averageWaterDrunk: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    
    var isGraphViewShowing = false
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var graphView: GraphView!
    
    //Counter outlets
    @IBOutlet weak var counterView: CounterView!
    @IBOutlet weak var counterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        counterLabel.text = String(counterView.counter)
        checkTotal()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnPushButton(_ button: PushButtonView) {
        if button.isAddButton {
            counterView.counter += 1
        } else {
            if counterView.counter > 0 {
                counterView.counter -= 1
            }
        }
        counterLabel.text = String(counterView.counter)
        if isGraphViewShowing {
            counterViewTap(nil)
        }
        checkTotal()
    }
    
    func checkTotal() {
        if counterView.counter >= 8 {
            medalView.showMedal(true)
        } else {
            medalView.showMedal(false)
        }
    }
    
    @IBAction func counterViewTap(_ gesture:UITapGestureRecognizer?) {
        if (isGraphViewShowing) {
            
            //hide Graph
            UIView.transition(from: graphView,
                              to: counterView,
                              duration: 1.0,
                              options: [UIViewAnimationOptions.transitionFlipFromLeft,
                                        UIViewAnimationOptions.showHideTransitionViews],
                              completion:nil)
        } else {
            
            //show Graph
            
            setupGraphDisplay()
            
            UIView.transition(from:counterView,
                              to: graphView,
                              duration: 1.0,
                              options: [UIViewAnimationOptions.transitionFlipFromRight,
                                        UIViewAnimationOptions.showHideTransitionViews],
                              completion: nil)
        }
        isGraphViewShowing = !isGraphViewShowing
    }
    
    func setupGraphDisplay() {
        
        //Use 7 days for graph - can use any number,
        //but labels and sample data are set up for 7 days
        let noOfDays:Int = 30
        
        //1 - replace last day with today's actual data
        //    graphView.graphPoints[graphView.graphPoints.count-1] = counterView.counter
        
        
        //code using the 60 day sample data instead of 7 days
        graphView.graphPoints = getGraphPoints(noOfDays)
        
        
        //2 - indicate that the graph needs to be redrawn
        graphView.setNeedsDisplay()
        
        maxLabel.text = "\(graphView.graphPoints.max() ?? 0)"
        
        //3 - calculate average from graphPoints
        let average = graphView.graphPoints.reduce(0, +)
            / graphView.graphPoints.count
        averageWaterDrunk.text = "\(average)"
        
        //set up labels
        //day of week labels are set up in storyboard with tags
        //today is last day of the array need to go backwards
        
        //4 - get today's day number
        let calendar = Calendar.current
        var weekday = calendar.component(.weekday, from: Date())
        
        let days = ["S", "S", "M", "T", "W", "T", "F"]
        
        //5 - set up the day name labels with correct day
        for i in (1...days.count).reversed() {
            if let labelView = graphView.viewWithTag(i) as? UILabel {
                if weekday == 7 {
                    weekday = 0
                }
                labelView.text = days[weekday]
                weekday -= 1
                if weekday < 0 {
                    weekday = days.count - 1
                }
            }
        }
    }
    
    //extract data from dataArray
    func getGraphPoints(_ noOfDays: Int) -> [Int]{
        
        //array of tuples
        //latest date is first in array
        var dataArray:[(Date, Int)] = sampleData
        
        //split array to get noOfDays - 1 entries (today will be an extra entry)
        //Note on option + click that newArray is a Slice<(NSDate, Int)>
        //Slices do not have all the methods that Arrays do (eg .map)
        
        let splitIndex = min(dataArray.count, noOfDays-1)
        
        var newArray = dataArray[0..<splitIndex]
        newArray.insert((Date(), counterView.counter), at: 0)
        
        //sort into ascending order for graph
        let ascendingOrder = { (date1: (Date, Int), date2: (Date, Int)) -> Bool in
            return date1.0.compare(date2.0) == .orderedAscending }
        let sortedDataArray = newArray.sorted(by: ascendingOrder)
        
        //extract the points into an array - don't need dates at this time
        return sortedDataArray.map { $1 }
    }
    
}

