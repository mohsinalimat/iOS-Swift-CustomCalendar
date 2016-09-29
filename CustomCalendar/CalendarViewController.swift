//
//  CalendarViewController.swift
//  CustomCalendar
//
//  Created by Ömer Faruk Öztürk on 29/09/2016.
//  Copyright © 2016 omerfarukozturk. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var monthNameLabel: UILabel!
    
    // Set total month before and after current date.
    let totalMonthCount : Int = 25
    
    var selectedMonth = NSDate()
    
    var calendarArrayForSection : Dictionary<Int, Array<Array<CalendarItemModel>>> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calendarCollectionView.delegate = self
        self.calendarCollectionView.dataSource = self
        self.calendarCollectionView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateCalendarView(12)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.calendarCollectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: 48, inSection: 12), atScrollPosition: UICollectionViewScrollPosition.Right, animated: false)
    }

    // MARK: Collectionview delegates
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 49
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.totalMonthCount
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        // Set cell width to 100%
        let collectionViewWidth = (self.view.frame.width - 6) / 7
        return CGSize(width: collectionViewWidth, height: collectionViewWidth)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if indexPath.row % 7 == 0 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("dayNameCell", forIndexPath: indexPath) as! INGCalendarDayNameCell
            cell.cellTitle.text = CalendarManager.sharedInstance.getDayShortName(indexPath.row / 7)
            
            return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("calendarDayCell", forIndexPath: indexPath) as! INGCalendarViewCell
            
            let item = self.getCalendarItem(indexPath)
            
            cell.setupCell(item)
            
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let item = self.getCalendarItem(indexPath)
        print("Date : \(item.date)")
    }
    
    func getCalendarItem(indexPath : NSIndexPath) -> CalendarItemModel {
        var calendarArrayForSection : Array<Array<CalendarItemModel>> = []
        
        if let array = self.calendarArrayForSection[indexPath.section] {
            calendarArrayForSection = array
        } else {
            calendarArrayForSection = CalendarManager.sharedInstance.getCalendarArray(CalendarManager.sharedInstance.getMonthAfterDate(NSDate(), after: indexPath.section - 12))
            self.calendarArrayForSection[indexPath.section] = calendarArrayForSection
        }
        
        let item = calendarArrayForSection[indexPath.row / 7][indexPath.row % 7]
        
        return item
    }
    
    @IBAction func previousMonthAction(sender: UIButton) {
        
        if let visibleItem = self.calendarCollectionView.indexPathsForVisibleItems().first {
            let previousSection = visibleItem.section - 1
            if previousSection >= 0 {
                self.calendarCollectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: 0, inSection: previousSection), atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
                self.updateCalendarView(previousSection)
            }
        }
    }
    
    @IBAction func nextMonthAction(sender: UIButton) {
        if let visibleItem = self.calendarCollectionView.indexPathsForVisibleItems().last {
            
            let nextSection = visibleItem.section + 1
            if nextSection < self.calendarCollectionView.numberOfSections() {
                
                self.calendarCollectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: 48, inSection: nextSection), atScrollPosition: UICollectionViewScrollPosition.Right, animated: true)
                self.updateCalendarView(nextSection)
            }
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let pageWidth = self.calendarCollectionView.frame.size.width
        let pageIndex = Int(self.calendarCollectionView.contentOffset.x / pageWidth)
        
        self.updateCalendarView(pageIndex)
    }
    
    // MARK: Hepler functions
    
    func updateCalendarView(pageIndex: Int){
        
        self.selectedMonth = CalendarManager.sharedInstance.getMonthAfterDate(NSDate(), after:pageIndex - 12)
        
        // Set month name.
        self.monthNameLabel.text = self.selectedMonth.getMonthName() + " " + self.selectedMonth.getYear()
    }
}

struct  CalendarItemModel {
    var title : String?
    var day : Int?
    var isInCurrentMonth : Bool = true
    var date : NSDate?
}

class INGCalendarViewCell : UICollectionViewCell{
    @IBOutlet weak var cellTitle: UILabel!
    
    func setupCell(data: CalendarItemModel){
        self.cellTitle.text = data.title
        self.cellTitle.textColor = UIColor.grayColor().colorWithAlphaComponent(data.isInCurrentMonth ? 1.0 : 0.4)
        
        self.layer.borderColor = UIColor.orangeColor().CGColor
        self.layer.borderWidth = data.isInCurrentMonth && data.date!.isToday() ? 1.0 : 0.0
        
    }
}

class INGCalendarDayNameCell : UICollectionViewCell{
    @IBOutlet weak var cellTitle: UILabel!
}