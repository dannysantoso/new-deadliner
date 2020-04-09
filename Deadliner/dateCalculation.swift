//
//  dateCalculation.swift
//  Deadliner
//
//  Created by Alfon on 09/04/20.
//  Copyright © 2020 Peter Andrew. All rights reserved.
//

import Foundation


/*
 How to use:
 1. call funcition calculateDate:
 
     if you want to calculate date length to the time task has to be done:
     - calculateDate(start: Date(), end: startDate)
     
     if you want to calculate how much time left you have to finish the task:
     - caluclateDate(start: Date(), end: endDate)
     
     if you want to calculate overdue time:
     - calculateDate(start: endDate(), end: Date())
 
 2. all the return is in String format, so you can put it directly to text label
 
 */



//Calculate date using Date parameters
func calculateDate(start: Date, end: Date) -> String{
    return dateCalculation(start: start, end: end)
}


//Calculate date using String parameters
func calculateDate(start: String, end: String) -> String{
    let startDate = stringtoDateFormatter(dateToBeFormatted: start)
    let endDate = stringtoDateFormatter(dateToBeFormatted: end)
    return dateCalculation(start: startDate, end: endDate)
}

//Calculate when only start is in String format
func calculateDate(start: String, end: Date) -> String{
    let startDate = stringtoDateFormatter(dateToBeFormatted: start)
    return dateCalculation(start: startDate, end: end)
}

//Calculate when only end is in String format
func calculateDate(start: Date, end: String) -> String{
    let endDate = stringtoDateFormatter(dateToBeFormatted: end)
    return dateCalculation(start: start, end: endDate)
}


//Calculate function
private func dateCalculation(start: Date, end: Date) -> String{
    let calculateDate = end.timeIntervalSince(start)
    let hour = floor(calculateDate / 60 / 60)
    if (hour < 24){
        let minutes = floor((calculateDate - (hour * 60 * 60)) / 60)
        if(hour < 1){
            return "\(Int(minutes)) Minutes"
        }
        return "\(Int(hour)) Hours \(Int(minutes)) Minutes"
    }
    let days = floor(hour/24)
    return "\(Int(days)) Days"
}

//Formatting string to date
func stringtoDateFormatter(dateToBeFormatted: String) -> Date{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM d, yyyy h:mm a"
    return dateFormatter.date(from: dateToBeFormatted)!
}
