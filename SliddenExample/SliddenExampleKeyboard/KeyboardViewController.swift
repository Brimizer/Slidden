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
    ["shift", "Z", "X", "C", "V", "B", "N", "M", "backspace"],     ["123", "next", "space", "return"]]


class KeyboardViewController: Slidden.KeyboardViewController {
    var updatedConstraints = false
    var heightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add the keys we need to the keyboard
        
        //setupKeysSimple()
        setupKeysFullEnglish()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let newHeight: CGFloat = 270
        heightConstraint = NSLayoutConstraint(item: self.view, attribute:NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem:nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: newHeight)
        heightConstraint.priority = 999
        self.view.addConstraint(heightConstraint)

//        self.view.setNeedsUpdateConstraints()
        
//        for (index, constraint) in enumerate(self.view.constraints()) {
//            println("---------\n")
//            println(constraint)
//            let lookingFor = constraint as NSLayoutConstraint
//            if lookingFor.firstAttribute == NSLayoutAttribute.Height {
//                heightConstraint = constraint as NSLayoutConstraint
//            }
//        }
        
    }
    
    func setupKeysSimple() {
        let helloKey = KeyboardKeyView(type: .Character, keyCap: "Hello", outputText: "Hello")
        helloKey.textColor = UIColor.whiteColor()
        helloKey.color = UIColor.blueColor()
        self.keyboardView.addKey(helloKey, row: 0)
        
        let worldKey = KeyboardKeyView(type: .Character, keyCap: "World", outputText: "World")
        worldKey.textColor = UIColor.whiteColor()
        worldKey.color = UIColor.redColor()
        self.keyboardView.addKey(worldKey, row: 0)
        
        let iloveKey = KeyboardKeyView(type: .Character, keyCap: "I Love", outputText: "I <3")
        iloveKey.textColor = UIColor.whiteColor()
        iloveKey.color = UIColor.redColor()
        self.keyboardView.addKey(iloveKey, row: 1)
        
        let youKey = KeyboardKeyView(type: .Character, keyCap: "You", outputText: "U!")
        youKey.textColor = UIColor.whiteColor()
        youKey.color = UIColor.blueColor()
        self.keyboardView.addKey(youKey, row: 1)
    }
    
    func setupKeysFullEnglish() {
        for (rowIndex, row) in enumerate(englishKeys) {
            for (keyIndex, key) in enumerate(row) {
                var type: KeyboardKeyView.KeyType!
                
                switch key {
                case "shift":
                    type = .Shift
                case "space":
                    type = .Space
                case "next":
                    type = .KeyboardChange
                case "backspace":
                    type = .Backspace
                case "123":
                    type = .ModeChange
                case "return":
                    type = .Return
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
                } else if keyboardKey.type == KeyboardKeyView.KeyType.Shift {
                    let img = UIImage(named:"Shift")
                    keyboardKey.image = img
                    keyboardKey.imageView.contentMode = .Center
                    keyboardKey.shouldColorImage = true
                }
                self.keyboardView.addKey(keyboardKey, row: rowIndex)
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
        super.textDidChange(textInput)
    }
    
    ///MARK: Inherited Delegate Methods
    override func keyPressed(key: KeyboardKeyView) {
        super.keyPressed(key)
    }
    
    override func returnKeyPressed(key: KeyboardKeyView) {
//        heightConstraint.constant = 300
    }
}
