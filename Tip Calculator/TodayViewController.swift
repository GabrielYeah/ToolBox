//
//  TodayViewController.swift
//  Tip Calculator
//
//  Created by Gabriel Yeah on 12/24/14.
//  Copyright (c) 2014 Haishan Ye. All rights reserved.
//

import UIKit
import NotificationCenter

enum TipLevel {
    case Satisfied
    case Standard
    case Unsatisfied
    mutating func changeLevel() {
        switch self {
        case .Satisfied:
            self = .Unsatisfied
        case .Unsatisfied:
            self = .Standard
        case .Standard:
            self = .Satisfied
        }
    }
    
    func color() -> UIColor {
        var color = UIColor.whiteColor()
        switch self {
        case .Satisfied:
            color = UIColor.UIColorFromRGB(0x09BB44, alpha: 1.0)
        case .Unsatisfied:
            color = UIColor.UIColorFromRGB(0xEA5251, alpha: 1.0)
        case .Standard:
            color = UIColor.UIColorFromRGB(0x0096DA, alpha: 1.0)
        }
        return color
    }
}

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var resultButton: UIButton!
    @IBOutlet weak var currentValueLabel: UILabel!
    
    var currentValue : String = "" {
        didSet {
            currentValueLabel.text = currentValue
        }
    }
    
    var tipLevel : TipLevel = .Standard {
        didSet {
            updateResult()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize.height = 176
        updateButtons()
    }
    
    func updateButtons() {
        for i in 1...12 {
            if let button = view.viewWithTag(i) as? UIButton {
                // TODO: Update button appearance
//                button.layer.borderWidth = 1
//                button.layer.borderColor = button.currentTitleColor.CGColor
                button.layer.cornerRadius = button.frame.width / 2
                button.backgroundColor = UIColor.UIColorFromRGB(0xF7F7F7, alpha: 0.1)
                
//                var gradientLayer = CAGradientLayer()
//                gradientLayer.frame = button.frame
//                gradientLayer.colors = [UIColor.UIColorFromRGB(0x55EFCB, alpha: 0.3).CGColor, UIColor.UIColorFromRGB(0x5BCAFF, alpha: 0.3).CGColor]
//                gradientLayer.locations = [0.0, 1.0]
//                button.layer.addSublayer(gradientLayer)
            }
        }
    }
    
    func updateResult() {
        resultButton.setTitleColor(tipLevel.color(), forState: .Normal)
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        completionHandler(NCUpdateResult.NewData)
    }
    
    func clear() {
        currentValue = "0"
    }
    
    func changeLevel() {
        tipLevel.changeLevel()
    }
    
    @IBAction func didClickButton(sender: UIButton) {
        switch sender.tag {
        case 1...11:
            if let title = sender.currentTitle {
                currentValue += title
            }
        case 12:
            clear()
        case 13:
            changeLevel()
        default:
            return
        }
    }
}

extension UIColor {
    class func UIColorFromRGB(rgbValue: UInt, alpha: CGFloat) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}
