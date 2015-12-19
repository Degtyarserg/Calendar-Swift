//
//  WeekDayView.swift
//  TreatMe
//
//  Created by Degtyar Sergio on 24.11.15.
//  Copyright © 2015 MutualCore. All rights reserved.
//

import UIKit

class WeekDayView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 1.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor = UIColor.lightGrayColor() {
        didSet {
            layer.borderColor = borderColor.CGColor
        }
    }

}
