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
    mutating func changeLevel(level : NSInteger) {
        switch level {
        case 1:
            self = .Unsatisfied
        case 2:
            self = .Standard
        case 3:
            self = .Satisfied
        default:
            self = .Standard
        }
    }
    
    func color(alpha : CGFloat) -> UIColor {
        var color = UIColor.whiteColor()
        switch self {
        case .Satisfied:
            color = UIColor.UIColorFromRGB(0x09BB44, alpha: alpha)
        case .Unsatisfied:
            color = UIColor.UIColorFromRGB(0xEA5251, alpha: alpha)
        case .Standard:
            color = UIColor.UIColorFromRGB(0x0096DA, alpha: alpha)
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
        return 1.0 / 1.09 * factor + 1.0
    }
}

class TodayViewController: UIViewController, NCWidgetProviding {
    // MARK: Properties
    @IBOutlet weak var currentValueLabel: UILabel!
    @IBOutlet weak var functionButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    
    var sharing = false
    var sharingCount : Int = 1
    
    var currentValue : Double = 0.0 {
        didSet {
            updateResult()
        }
    }
    
    var tipLevel : TipLevel = .Standard {
        didSet {
            updateResult()
        }
    }
    
    var currentResult : Double {
        return currentValue * tipLevel.factor() / Double(sharingCount * 100)
    }
    
    // MARK: View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize.height = 220
        updateButtons()
        updateResult()
    }
    
    func updateButtons() {
        for i in 1...15 {
            if let button = view.viewWithTag(i) as? UIButton {
                switch i {
                case 12:
                    button.backgroundColor = TipLevel.Unsatisfied.color(0.5)
                case 13:
                    button.backgroundColor = TipLevel.Standard.color(0.5)
                case 14:
                    button.backgroundColor = TipLevel.Satisfied.color(0.5)
                case 15:
                    button.backgroundColor = UIColor.UIColorFromRGB(0xD2691E, alpha: 0.5)
                default:
                    button.backgroundColor = UIColor.UIColorFromRGB(0xF7F7F7, alpha: 0.1)
                }
            }
        }
        resultLabel.adjustsFontSizeToFitWidth = true;
        resultLabel.minimumScaleFactor = 0.5;
    }
    
    func updateResult() {
        currentValueLabel.text = String(format: "%.2f", currentValue / 100)
        resultLabel.text = String(format: "%.2f", currentResult)
    }
    
    func widgetMarginInsetsForProposedMarginInsets
        (defaultMarginInsets: UIEdgeInsets) -> (UIEdgeInsets) {
            var inset = defaultMarginInsets
            inset.bottom = 0
            inset.top = 0
            inset.left = 0
            inset.right = 0
            return inset
    }
    
    // MARK: Data Methods
    @IBAction func didClickButton(sender: UIButton) {
        switch sender.tag {
        case 15:
            handleSharingButton()
        case 11:
            clearContext()
        case 12...14:
            tipLevel.changeLevel(sender.tag - 11)
            resultLabel.textColor = tipLevel.color(1)
        default:
            appendNewCharacter(sender.currentTitle)
        }
    }
    
    func appendNewCharacter(title : String?) {
        if let title = title {
            currentValue = currentValue * 10.0 + Double(title.toInt()!)
        }
    }
    
    func handleSharingButton() {
        sharingCount++
        updateResult()
        functionButton.setTitle("+\(sharingCount)", forState: .Normal)
    }
    
    func clearContext() {
        sharing = false
        sharingCount = 1
        functionButton.setTitle("+\(sharingCount)", forState: .Normal)
        currentValue = 0.0
        updateResult()
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
