//
//  SampleData.swift
//  Flo
//
//  Created by Caroline Begbie on 22/12/2014.
//  Edited by Eric Cerney on 13/1/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import Foundation

let sampleData = setupSampleData()

func setupSampleData() -> [(Date, Int)] {
  
  //set up weighting for sample data
  //glasses drunk are never less than two, and most likely 3,4, 5
  let noOfGlasses = [2, 3, 4, 5, 6, 7, 8, 9, 10, 3, 4, 5, 6, 7, 8, 3, 4, 5]
  
  var dataArray:[(Date, Int)] = []
  
  //Set up 60 days worth of sample data
  //Sets up 60 days prior to this one
  //with random glasses drunk (0 to 8)
  
  var date = Date()
  let calendar = Calendar.current
  let componentOptions: Set<Calendar.Component> = [.day, .month, .year]
  var components = calendar.dateComponents(componentOptions, from: date)
  
  for i in 1...60 {
    components.day = components.day! - 1
    let date = calendar.date(from: components)!
    let glassesDrunk = noOfGlasses[Int(arc4random()) % (noOfGlasses.count - 1)]
    let data = (date, glassesDrunk)
    dataArray.append(data)
  }
  return dataArray
}
