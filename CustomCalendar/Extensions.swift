//
//  Extensions.swift
//  CustomCalendar
//
//  Created by Ömer Faruk Öztürk on 29/09/2016.
//  Copyright © 2016 omerfarukozturk. All rights reserved.
//

import Foundation

extension NSDate {
    func startOfMonth() -> NSDate? {
        guard
            let cal: NSCalendar = NSCalendar.currentCalendar(),
            let comp: NSDateComponents = cal.components([.Year, .Month], fromDate: self) else { return nil }
        comp.to12pm()
        return cal.dateFromComponents(comp)!
    }
    
    func isToday() -> Bool {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        var components = calendar.components(([.Era, .Year, .Month, .Day]), fromDate: NSDate())
        let today = calendar.dateFromComponents(components)!
        
        components = calendar.components(([.Era, .Year, .Month, .Day]), fromDate:self)
        let selectedPickerDate = calendar.dateFromComponents(components)!
        
        if selectedPickerDate.isEqualToDate(today){
            return true
        } else {
            return false
        }
    }
    
    func getYear() -> String{
        let dateFormatter : NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY"
        return dateFormatter.stringFromDate(self)
    }
    
    func getDateTimeComponents() -> NSDateComponents? {
        // get the components
        // get the user's calendar
        let userCalendar = NSCalendar.currentCalendar()
        
        // choose which date and time components are needed
        let requestedComponents: NSCalendarUnit = [
            NSCalendarUnit.Year,
            NSCalendarUnit.Month,
            NSCalendarUnit.Day,
            NSCalendarUnit.Hour,
            NSCalendarUnit.Minute,
            NSCalendarUnit.Second
        ]
        
        let dateTimeComponents = userCalendar.components(requestedComponents, fromDate: self)
        return dateTimeComponents
    }
    
    func getMonthName() -> String {
        var monthName = ""
        if let dateComponents = self.getDateTimeComponents() {
            let monthVal = String(format: "%02d", dateComponents.month)
            monthName = getMonthName(monthVal)
        }
        return monthName
    }
    
    func getMonthName(month: String) -> String {
        if month == "01" {
            return "OCAK"
        } else if month == "02" {
            return "ŞUBAT"
        } else if month == "03" {
            return "MART"
        } else if month == "04" {
            return "NİSAN"
        } else if month == "05" {
            return "MAYIS"
        } else if month == "06" {
            return "HAZİRAN"
        } else if month == "07" {
            return "TEMMUZ"
        } else if month == "08" {
            return "AĞUSTOS"
        } else if month == "09" {
            return "EYLÜL"
        } else if month == "10" {
            return "EKİM"
        } else if month == "11" {
            return "KASIM"
        } else if month == "12" {
            return "ARALIK"
        }
        
        return ""
    }
}




internal extension NSDateComponents {
    func to12pm() {
        self.hour = 12
        self.minute = 0
        self.second = 0
    }
}
