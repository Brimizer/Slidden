//
//  KeyboardViewController.swift
//  SliddenExampleKeyboard
//
//  Created by Daniel Brim on 9/11/14.
//  Copyright (c) 2014 Daniel Brim. All rights reserved.
//

import UIKit
import Slidden

let englishKeys: [[String]] = [["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
    ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
    ["shift", "Z", "X", "C", "V", "B", "N", "M", "⬅︎"],     ["123", "next", "space", "translate", "return"]]

class KeyboardViewController: SliddenKeyboardViewController {
    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        // Add custom view sizing constraints here
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add the keys we need to the keyboard
        setupKeys()
    }
    
    func setupKeys() {
        for (rowIndex, row) in enumerate(englishKeys) {
            for (keyIndex, key) in enumerate(row) {
                var type: KeyboardKeyView.KeyType = .Character
                
                switch key {
                case "shift":
                    type = .Shift
                case "space":
                    type = .Space
                case "next":
                    type = .KeyboardChange
                case "⬅︎":
                    type = .Backspace
                case "123":
                    type = .ModeChange
                case "return":
                    type = .Return
                case "translate":
                    type = .Translate
                default:
                    type = .Character
                }
                let keyboardKey = KeyboardKeyView(type: type, keyCap: key, outputText: key)
                keyboardKey.textColor = UIColor.whiteColor()
                keyboardKey.color = ((rowIndex % 2) == 0) ? UIColor(hex:0x5B568A) : UIColor(hex: 0x443F78)
                keyboardKey.selectedColor = ((rowIndex % 2) == 0) ? UIColor(hex: 0x443F78) : UIColor(hex: 0x5B568A)
                if keyboardKey.type == KeyboardKeyView.KeyType.KeyboardChange {
                    let img = UIImage(named:"NextKeyboard")
                    keyboardKey.image = img
                    keyboardKey.imageView.contentMode = .Center
                    keyboardKey.shouldColorImage = true
                    //                    keyboardKey.contentInset = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
                } else if keyboardKey.type == KeyboardKeyView.KeyType.Shift {
                    let img = UIImage(named:"Shift")
                    keyboardKey.image = img
                    keyboardKey.imageView.contentMode = .Center
                    keyboardKey.shouldColorImage = true
                    
                    //                    keyboardKey.contentInset = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
                }
                self.keyboardView!.addKey(keyboardKey, row: rowIndex)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    override func textWillChange(textInput: UITextInput) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(textInput: UITextInput) {
        // The app has just changed the document's contents, the document context has been updated.
//    
//        var textColor: UIColor
//        var proxy = self.textDocumentProxy as UITextDocumentProxy
//        if proxy.keyboardAppearance == UIKeyboardAppearance.Dark {
//            textColor = UIColor.whiteColor()
//        } else {
//            textColor = UIColor.blackColor()
//        }
//        self.nextKeyboardButton.setTitleColor(textColor, forState: .Normal)
    }

}
