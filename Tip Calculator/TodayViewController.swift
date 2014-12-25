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
    
    func factor() -> Double {
        var factor = 1.0
        switch self {
        case .Satisfied:
            factor = 0.2
        case .Unsatisfied:
            factor = 0.1
        case .Standard:
            factor = 0.15
        }
        return 1.0 / 1.09 * factor + 1
    }
}

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var resultButton: UIButton!
    @IBOutlet weak var currentValueLabel: UILabel!
    @IBOutlet weak var functionButton: UIButton!
    
    var sharing = false
    var sharingCount = 1
    
    var currentValue : String = "0" {
        didSet {
            currentValueLabel.text = currentValue
            updateResult()
        }
    }
    
    var tipLevel : TipLevel = .Standard {
        didSet {
            updateResult()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize.height = 172
        updateButtons()
        updateResult()
    }
    
    func updateButtons() {
        for i in 1...12 {
            if let button = view.viewWithTag(i) as? UIButton {
                button.layer.cornerRadius = button.frame.width / 2
                button.backgroundColor = UIColor.UIColorFromRGB(0xF7F7F7, alpha: 0.1)
            }
        }
        resultButton.titleLabel?.adjustsFontSizeToFitWidth = true;
        resultButton.titleLabel?.minimumScaleFactor = 0.5;
    }
    
    func updateResult() {
        resultButton.setTitleColor(tipLevel.color(), forState: .Normal)
        resultButton.setTitle(String(format: "%.1f", (currentValue as NSString).doubleValue * tipLevel.factor() / Double(sharingCount)), forState: .Normal)
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        completionHandler(NCUpdateResult.NewData)
    }
    
    func widgetMarginInsetsForProposedMarginInsets
        (defaultMarginInsets: UIEdgeInsets) -> (UIEdgeInsets) {
            var inset = defaultMarginInsets
            inset.bottom = 10
            inset.top = 10
            return inset
    }
    
    @IBAction func didClickButton(sender: UIButton) {
        switch sender.tag {
        case 1...10:
            if let title = sender.currentTitle {
                if currentValue == "0" {
                    currentValue = title
                } else {
                    currentValue += title
                }
            }
        case 11:
            if (!sharing) {
                currentValue += "."
                sharing = true
            } else {
                sharingCount++
                updateResult()
            }
            functionButton.setTitle("+\(sharingCount)", forState: .Normal)
        case 12:
            sharing = false
            currentValue = "0"
            sharingCount = 1
            functionButton.setTitle(".", forState: .Normal)
        case 13:
            tipLevel.changeLevel()
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
