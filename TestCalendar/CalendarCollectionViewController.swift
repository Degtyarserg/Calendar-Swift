//
//  CalendarCollectionViewController.swift
//  TestCalendar
//
//  Created by Degtyar Sergio on 26.11.15.
//  Copyright © 2015 Degtyar Sergio. All rights reserved.
//

import UIKit

class CalendarCollectionViewController: UICollectionViewController {
    
    // MARK: Properties
    
    let reuseIdentifier = "CalendarCollectionViewCell"
    
    var date = NSDate()
    var previousMonthFromDate = NSDate()
    var nextDay = 0
    var previousDay = 0
    let daysInWeek = 7
    let maxRowsCount = 6
    private var monthInfo = [Int]()
    
    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: PrivateMethods

    private func returnDateForMonth(month:NSInteger, year:NSInteger, day:NSInteger) -> NSDate {
        let comp = NSDateComponents()
        comp.month = month
        comp.year = year
        comp.day = day
        
        let grego = NSCalendar.currentCalendar()
        return grego.dateFromComponents(comp)!
    }
    
    private func returnDateFofmatterFromDate(date: NSDate) -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMddyyyy"
        return dateFormatter.stringFromDate(date)
    }
    
    private func returnDayFromDate(date: NSDate) -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.stringFromDate(date)
    }
    
    private func returnPreviousMonthFromDate(date: NSDate) -> NSDate {
        let components = NSDateComponents()
        components.setValue(-1, forComponent: .Month);
        return NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: self.date, options: NSCalendarOptions(rawValue: 0))!
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components([NSCalendarUnit.Month, NSCalendarUnit.Year, NSCalendarUnit.Day], fromDate: date)
        let firstDay = self.returnDateForMonth(dateComponents.month, year: dateComponents.year, day: 1)
        
        var firstWeekdayOfMonthIndex = NSCalendar.currentCalendar().component(NSCalendarUnit.Weekday, fromDate: firstDay)
        
        let numberOfDaysInMonth = NSCalendar.currentCalendar().rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: date).length

        firstWeekdayOfMonthIndex = firstWeekdayOfMonthIndex - 1
        firstWeekdayOfMonthIndex = (firstWeekdayOfMonthIndex + 6) % 7
        
        monthInfo = [firstWeekdayOfMonthIndex, numberOfDaysInMonth]
        
        previousMonthFromDate = self.returnPreviousMonthFromDate(self.date)
        previousDay = NSCalendar.currentCalendar().rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: previousMonthFromDate).length - (firstWeekdayOfMonthIndex - 1)


        return self.daysInWeek * self.maxRowsCount
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let dayCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CalendarCollectionViewCell

        let fdIndex = monthInfo[0]
        let nDays = monthInfo[1]
        
        if indexPath.item >= fdIndex && indexPath.item < fdIndex + nDays {
            
            dayCell.dayUILabel.text = String(indexPath.item - fdIndex + 1)
            
            if returnDateFofmatterFromDate(NSDate()) == returnDateFofmatterFromDate(self.date)
                && dayCell.dayUILabel.text == "\(returnDayFromDate(self.date))"{
                    dayCell.dayUILabel.textColor = UIColor.blueColor()
            }
            
        } else if indexPath.item < fdIndex {
            dayCell.dayUILabel.text = "\(previousDay)"
            dayCell.dayUILabel.textColor = UIColor.lightGrayColor()
            previousDay++
        } else if indexPath.item >= fdIndex + nDays && fdIndex + nDays > 35 {
            nextDay++
            dayCell.dayUILabel.text = "\(nextDay)"
            dayCell.dayUILabel.textColor = UIColor.lightGrayColor()
        } else if indexPath.item >= fdIndex + nDays && fdIndex + nDays <= 35 && indexPath.item < 35{
            nextDay++
            dayCell.dayUILabel.text = "\(nextDay)"
            dayCell.dayUILabel.textColor = UIColor.lightGrayColor()
        } else {
            dayCell.dayUILabel.text = ""
            dayCell.hidden = true
        }
        return dayCell
    }
    
//     MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

            return CGSize(width: self.collectionView!.frame.size.width / CGFloat(self.daysInWeek), height: self.collectionView!.frame.size.height / CGFloat(self.maxRowsCount))
    }

    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {

            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

}

