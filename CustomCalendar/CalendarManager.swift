//
//  CalendarManager.swift
//  CustomCalendar
//
//  Created by Ömer Faruk Öztürk on 29/09/2016.
//  Copyright © 2016 omerfarukozturk. All rights reserved.
//

import Foundation

class CalendarManager {
    // Singleton
    class var sharedInstance: CalendarManager {
        struct Static {
            static let instance: CalendarManager = CalendarManager()
        }
        return Static.instance
    }
    
    // get n'th next month from now.
    func getMonthAfterDate(date: NSDate,after: Int) -> NSDate {
        var nextDate = date
        let cal = NSCalendar(calendarIdentifier:NSCalendarIdentifierGregorian)!
        if #available(iOS 8.0, *) {
            nextDate = cal.dateByAddingUnit(.Month, value: after, toDate: date, options: [])!
        } else {
            // Fallback on earlier versions
            let component = NSDateComponents()
            component.month = after
            nextDate = cal.dateByAddingComponents(component, toDate: date, options: NSCalendarOptions(rawValue: 0))!
        }
        
        return nextDate
    }
    
    func getDayShortName(day : Int) -> String{
        
        switch day {
        case 0 : return "Pzt"
        case 1 : return "Sal"
        case 2 : return "Çar"
        case 3 : return "Per"
        case 4 : return "Cum"
        case 5 : return "Cts"
        case 6 : return "Paz"
        default: return ""
        }
    }
    
    func getFirstDayOfMonthIndex(date: NSDate) -> Int{
        let startDate = date.startOfMonth()
        let comp =  NSCalendar.currentCalendar().components(NSCalendarUnit.Weekday, fromDate: startDate!)
        return  ((comp.weekday + 5) % 7)
        
    }
    
    func getCurrentDayIndex()-> Int {
        let comp =  NSCalendar.currentCalendar().components(NSCalendarUnit.Day, fromDate: NSDate())
        return comp.day
    }
    
    func getCalendarArray(forDate: NSDate) -> [[CalendarItemModel]]{
        
        let cal = NSCalendar(calendarIdentifier:NSCalendarIdentifierGregorian)!
        
        let previousMonthDaysCount = cal.rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: self.getMonthAfterDate(forDate,after: -1)).length
        
        let currentMonthDayCount = cal.rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: forDate).length
        
        let firstDayOfMonth = forDate.startOfMonth()!
        
        var monthArray : [[CalendarItemModel]] = []
        
        // add day column names
        monthArray.append(Array<CalendarItemModel>())
        for dayColumn in 0...6 {
            var item = CalendarItemModel()
            item.title = self.getDayShortName(dayColumn)
            monthArray[0].append(item)
        }
        
        
        // add previous month last days
        monthArray.append(Array<CalendarItemModel>())
        let currentMonthFirstDay = self.getFirstDayOfMonthIndex(forDate)
        for prevDays in previousMonthDaysCount - currentMonthFirstDay..<previousMonthDaysCount {
            var item = CalendarItemModel()
            item.title = (prevDays + 1).description
            item.isInCurrentMonth = false
            item.date = firstDayOfMonth.dateByAddingTimeInterval(60 * 60 * 24 * Double(prevDays - previousMonthDaysCount))
            monthArray[1].append(item)
        }
        
        var dayNumber : Int = 1
        
        // add current month days
        for monthDays in currentMonthFirstDay..<currentMonthFirstDay + currentMonthDayCount {
            
            // add row
            if monthDays % 7 == 0 {
                monthArray.append(Array<CalendarItemModel>())
            }
            
            var item = CalendarItemModel()
            item.title = dayNumber.description
            item.day = dayNumber
            item.date = firstDayOfMonth.dateByAddingTimeInterval(60 * 60 * 24 * Double(dayNumber - 1))
            dayNumber += 1
            
            monthArray[(monthDays / 7) + 1].append(item)
        }
        
        // next month days
        var nextMonthDays = 1
        for day in currentMonthFirstDay + currentMonthDayCount..<42 {
            
            // add row
            if day % 7 == 0 {
                monthArray.append(Array<CalendarItemModel>())
            }
            
            var item = CalendarItemModel()
            item.title = (nextMonthDays).description
            item.isInCurrentMonth = false
            item.date = firstDayOfMonth.dateByAddingTimeInterval(60 * 60 * 24 * Double(currentMonthDayCount + nextMonthDays - 1))
            nextMonthDays += 1
            
            monthArray[(day / 7) + 1].append(item)
        }
        
        var rotatedArray = Array<Array<CalendarItemModel>>()
        
        for row in 0..<monthArray.count {
            rotatedArray.append(Array<CalendarItemModel>())
            for column in 0..<monthArray[row].count {
                rotatedArray[row].append(monthArray[column][row])
            }
        }
        
        return rotatedArray
    }
}