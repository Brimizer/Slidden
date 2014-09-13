//
//  KeyboardViewController.swift
//  TrypeKeyboard
//
//  Created by Daniel Brim on 9/3/14.
//  Copyright (c) 2014 db. All rights reserved.
//

import UIKit

public class KeyboardViewController: UIInputViewController, KeyboardViewDelegate {

    @IBOutlet weak var nextKeyboardButton: UIButton!
    public var keyboardView: KeyboardView!
    
    public var textDocument: TextDocument!
    
    private var layoutConstrained: Bool = false
    private var spaceWaiting: Bool = false
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        let proxy = self.textDocumentProxy as UITextDocumentProxy
        textDocument = TextDocument(proxy: proxy)

        setupKeyboard()
    }
    
    /// Setup a view with the standard defaults
    func setupKeyboard() {
        
        self.keyboardView = KeyboardView()
        self.keyboardView.delegate = self
        self.keyboardView.currentLanguage = .English_US
        self.keyboardView.backgroundColor = UIColor.lightGrayColor()
        
        self.view.addSubview(keyboardView)
        self.view.setNeedsUpdateConstraints()
    }
    
//    func setupKeys() {
//        for (rowIndex, row) in enumerate(englishKeys) {
//            for (keyIndex, key) in enumerate(row) {
//                var type: KeyboardKeyView.KeyType = .Character
//                
//                switch key {
//                case "⇪":
//                    type = .Shift
//                case "space":
//                    type = .Space
//                case "next":
//                    type = .KeyboardChange
//                case "⬅︎":
//                    type = .Backspace
//                case "12":
//                    type = .ModeChange
//                case "return":
//                    type = .Return
//                case "translate":
//                    type = .Translate
//                default:
//                    type = .Character
//                }
//                let keyboardKey = KeyboardKeyView(type: type, keyCap: key, outputText: key)
//                keyboardKey.backgroundColor = UIColor.randomColor()
//                if keyboardKey.type == KeyboardKeyView.KeyType.KeyboardChange {
//                    let img = UIImage(named:"NextKeyboard")
//                    keyboardKey.image = img
//                    keyboardKey.imageView.contentMode = .Center
//                    keyboardKey.colorImage = true
////                    keyboardKey.contentInset = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
//                } else if keyboardKey.type == KeyboardKeyView.KeyType.Shift {
//                    let img = UIImage(named:"Shift")
//                    keyboardKey.imageView.contentMode = .Center
//                    keyboardKey.color = UIColor.whiteColor()
//                    keyboardKey.colorImage = true
//                    keyboardKey.image = img
//
//                    //                    keyboardKey.contentInset = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
//                }
//                self.keyboardView!.addKey(keyboardKey, row: rowIndex)
//            }
//        }
//    }
    
    public override func updateViewConstraints() {
        // Add custom view sizing constraints here
        super.updateViewConstraints()
        
        if !layoutConstrained {

            var left = NSLayoutConstraint(item: self.keyboardView, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 0.0)
            var top = NSLayoutConstraint(item: self.keyboardView, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 0.0)
            var right = NSLayoutConstraint(item: self.keyboardView, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1.0, constant: 0.0)
            var bottom = NSLayoutConstraint(item: self.keyboardView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
            left.priority = 999
            right.priority = 999
            bottom.priority = 999
            top.priority = 999
            self.view.addConstraints([left, right, top, bottom])
            
            layoutConstrained = true
        }
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    ///MARK: Text Management
    public override func textWillChange(textInput: UITextInput) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    public override func textDidChange(textInput: UITextInput) {
        // The app has just changed the document's contents, the document context has been updated.
        
        //var textToTranslate = getProperTextFrom(textInput)
        var proxy = self.textDocumentProxy as UITextDocumentProxy
        println("Text did change: \(self.textDocument.text())")
    }
    
    ///MARK: Key Actions
    func keyPressed(key: KeyboardKeyView) {
        UIDevice.currentDevice().playInputClick()
        spaceWaiting = false
        
        if let text = key.outputText {
            textDocument.insertText(text.lowercaseString)
        }
    }
    
    func backspaceKeyPressed(key: KeyboardKeyView) {
        UIDevice.currentDevice().playInputClick()

        textDocument.deleteBackward()
    }
    
    func spaceKeyPressed(key: KeyboardKeyView) {
        UIDevice.currentDevice().playInputClick()
        
        if spaceWaiting {
            textDocument.deleteBackward()
            textDocument.insertText(".")
            
            spaceWaiting = false
        } else {
            spaceWaiting = true
        }
        textDocument.insertText(" ")
    }
    
    func shiftKeyPressed(key: KeyboardKeyView) {
        UIDevice.currentDevice().playInputClick()

    }
    
    func returnKeyPressed(key: KeyboardKeyView) {
        UIDevice.currentDevice().playInputClick()

        textDocument.insertText("\n")
    }
    
    func modeChangeKeyPressed(key: KeyboardKeyView) {
        UIDevice.currentDevice().playInputClick()
    }
    
    func nextKeyboardKeyPressed(key: KeyboardKeyView) {
        UIDevice.currentDevice().playInputClick()

        self.advanceToNextInputMode()
    }
}
