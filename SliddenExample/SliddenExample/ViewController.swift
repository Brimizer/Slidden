//
//  ViewController.swift
//  SliddenExample
//
//  Created by Daniel Brim on 9/11/14.
//  Copyright (c) 2014 Daniel Brim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textBox: UITextView!
    
    var constraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardAppeared:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDisappeared:", name: UIKeyboardDidShowNotification, object: nil)
        
        constraint = NSLayoutConstraint(item: textBox, attribute: .BottomMargin, relatedBy: .Equal, toItem: self.view, attribute: .BottomMargin, multiplier: 1.0, constant: -20.0)
        self.view.addConstraint(constraint)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ///MARK: Keyboard
    func keyboardAppeared(notification: NSNotification) {
        if let info = notification.userInfo {
            let frame = (info["UIKeyboardFrameEndUserInfoKey"] as NSValue).CGRectValue()
            self.constraint.constant = -frame.size.height - 20;
        }
    }
    
    func keyboardDisappeared(notification: NSNotification) {
        
    }
}

