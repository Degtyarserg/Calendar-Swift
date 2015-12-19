//
//  CalendarCollectionViewCell.swift
//  TestCalendar
//
//  Created by Degtyar Sergio on 26.11.15.
//  Copyright © 2015 Degtyar Sergio. All rights reserved.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties

    @IBOutlet weak var dayUILabel: UILabel!
    @IBOutlet weak var appointmentUIView: UIView!
    
    let cellColorDefault = UIColor.clearColor()
    let borderColor = UIColor.blueColor()
    
    var date = NSDate()

    var isToday : Bool = false {
        didSet {
            if isToday == true {
                self.appointmentUIView.backgroundColor = self.borderColor
                self.dayUILabel.textColor = UIColor.whiteColor()
            }
        }
    }
    
    // MARK: LifeCycle

    override func layoutSubviews() {
        super.layoutSubviews()
        self.appointmentUIView.layoutIfNeeded()
        self.appointmentUIView.layer.cornerRadius = self.appointmentUIView.frame.size.width / 2
    }

}
