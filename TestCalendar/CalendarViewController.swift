//
//  CalendarViewController.swift
//  TestCalendar
//
//  Created by Degtyar Sergio on 26.11.15.
//  Copyright © 2015 Degtyar Sergio. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {

    // MARK: Properties

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet var todayBarButtonItem: UIBarButtonItem!
    
    var date = NSDate()
    var pageController = UIPageViewController()

    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createPageViewController()
        self.getMonthFromDate(self.date)
    }
    
    // MARK: IBAction
    
    @IBAction func todayAction(sender: UIBarButtonItem) {
        self.getTodayDateForController()
    }
    
    @IBAction func monthBeforAction(sender: UIButton) {
        guard
            let controllers = self.pageController.viewControllers else {
                return
        }
        let controller = controllers.first as! CalendarCollectionViewController
        
        
        let components = NSDateComponents()
        components.setValue(-1, forComponent: .Month);
        let date = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: controller.date, options: NSCalendarOptions(rawValue: 0))!
        
        self.date = date
        
        let pageItemController = getItemController(date)!
        let beforViewControllers: NSArray = [pageItemController]
        self.pageController.setViewControllers(beforViewControllers as! [CalendarCollectionViewController], direction: .Reverse, animated: true, completion: nil)
        getMonthFromDate(date)

    }
    
    @IBAction func nextMonthAction(sender: UIButton) {
        
        guard
            let controllers = self.pageController.viewControllers else {
                return
        }
        let controller = controllers.first as! CalendarCollectionViewController
        
        let components = NSDateComponents()
        components.setValue(1, forComponent: .Month);
        let date = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: controller.date, options: NSCalendarOptions(rawValue: 0))!
        
        self.date = date

        let pageItemController = getItemController(date)!
        let beforViewControllers: NSArray = [pageItemController]
        self.pageController.setViewControllers(beforViewControllers as! [CalendarCollectionViewController], direction: .Forward, animated: true, completion: nil)
        getMonthFromDate(date)

    }
    
    // MARK: PrivateMethods
    
    private func showTodayBarButtonItemForDate(date: NSDate) {
        if self.getDateFofmatterFromDate(NSDate()) != self.getDateFofmatterFromDate(date) {
            self.navigationItem.leftBarButtonItem = self.todayBarButtonItem
        } else {
            self.navigationItem.leftBarButtonItem = nil
        }
    }
    
    private func getDateFofmatterFromDate(date: NSDate) -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMyyyy"
        return dateFormatter.stringFromDate(date)
    }
    
    private func getTodayDateForController() {
        let durection: UIPageViewControllerNavigationDirection
        durection = (self.date.timeIntervalSince1970 > NSDate().timeIntervalSince1970) ? .Reverse : .Forward
        let pageItemController = getItemController(NSDate())!
        let viewControllers: NSArray = [pageItemController]
        self.pageController.setViewControllers(viewControllers as! [CalendarCollectionViewController], direction: durection, animated: true, completion: nil)
        getMonthFromDate(NSDate())
    }
    
    private func createPageViewController() {
        
        self.pageController = self.storyboard!.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        self.pageController.dataSource = self
        self.pageController.delegate = self

        let firstController = getItemController(self.date)!
        let startingViewControllers: NSArray = [firstController]
        self.pageController.setViewControllers(startingViewControllers as! [CalendarCollectionViewController], direction: .Forward, animated: true, completion: nil)
        
        self.pageController.view.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height)
        self.containerView.addSubview(self.pageController.view)
        addChildViewController(self.pageController)
    }
    
    private func getMonthFromDate(date: NSDate) {
        
        let monthsOffsetComponents = NSDateComponents()
        self.showTodayBarButtonItemForDate(date)

        if let yearDate = NSCalendar.currentCalendar().dateByAddingComponents(monthsOffsetComponents, toDate: date, options: NSCalendarOptions()) {
            let month = NSCalendar.currentCalendar().component(NSCalendarUnit.Month, fromDate: yearDate)
            let monthName = NSDateFormatter().monthSymbols[(month-1) % 12]
            let year = NSCalendar.currentCalendar().component(NSCalendarUnit.Year, fromDate: yearDate)
            self.monthLabel.text = monthName.uppercaseString + " " + String(year)
        }
    }
    
    private func getItemController(date: NSDate) -> CalendarCollectionViewController? {
        
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("CalendarCollectionViewController") as! CalendarCollectionViewController
        
        controller.date = date
        
        return controller
    }
    
}

extension CalendarViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // MARK: UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! CalendarCollectionViewController
        let components = NSDateComponents()
        components.setValue(-1, forComponent: .Month);
        let date = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: itemController.date, options: NSCalendarOptions(rawValue: 0))!
        
        self.date = date
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("CalendarCollectionViewController") as! CalendarCollectionViewController
        controller.date = date
        return controller
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! CalendarCollectionViewController
        let components = NSDateComponents()
        components.setValue(1, forComponent: .Month);
        let date = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: itemController.date, options: NSCalendarOptions(rawValue: 0))!
        
        self.date = date
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("CalendarCollectionViewController") as! CalendarCollectionViewController
        
        controller.date = date
        return controller
    }
    
    // MARK: UIPageViewControllerDelegate
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard
            let controllers = pageViewController.viewControllers else {
                return
        }
        let controller = controllers.first as! CalendarCollectionViewController
        self.getMonthFromDate(controller.date)
    }

}
