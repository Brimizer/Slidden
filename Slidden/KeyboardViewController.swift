//
//  KeyboardViewController.swift
//  TrypeKeyboard
//
//  Created by Daniel Brim on 9/3/14.
//  Copyright (c) 2014 db. All rights reserved.
//

import UIKit

public class KeyboardViewController: UIInputViewController, KeyboardViewDelegate, KeyboardViewDatasource {

    public enum Mode {
        case Alphabet
        case NumberSymbols1
        case NumberSymbols2
    }
    
    public var keyboardView: KeyboardView!
    public var textDocument: KeyboardTextDocument!
    public var autoShifted: Bool = true
    public var mode = Mode.Alphabet

    public var shouldLayoutKeyboardConstraintsAutomatically: Bool = true
    
    private var layoutConstrained: Bool = false
    private var spaceWaiting: Bool = false
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let proxy = self.textDocumentProxy as UITextDocumentProxy
        
        textDocument = KeyboardTextDocument(proxy: proxy)

        setupKeyboard()
        self.keyboardView.reloadKeys()
    }
    
    /// Setup a view with the standard defaults
    func setupKeyboard() {
        
        self.keyboardView = KeyboardView()
        self.keyboardView.delegate = self
        self.keyboardView.datasource = self
        self.keyboardView.currentLanguage = .English_US
        self.keyboardView.backgroundColor = UIColor.lightGray
        
        self.view.addSubview(keyboardView)
        self.view.setNeedsUpdateConstraints()
    }
    
    ///MARK: Keyboard Datasource
    public func numberOfRowsInKeyboardView(keyboardView: KeyboardView) -> Int {
        return 0
    }
    
    public func keyboardView(keyboardView: KeyboardView, numberOfKeysInRow row:Int) -> Int {
        return 0
    }
    
    public func keyboardView(keyboardView: KeyboardView, keyAtIndexPath indexPath: NSIndexPath) -> KeyboardKeyView? {
        return nil
    }
    
    ///MARK: View Layout
    public override func updateViewConstraints() {
        // Add custom view sizing constraints here
        super.updateViewConstraints()
        
        if !layoutConstrained {
            
            if shouldLayoutKeyboardConstraintsAutomatically {
                let left = NSLayoutConstraint(item: self.keyboardView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0.0)
                let top = NSLayoutConstraint(item: self.keyboardView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0.0)
                let right = NSLayoutConstraint(item: self.keyboardView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0.0)
                let bottom = NSLayoutConstraint(item: self.keyboardView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
                left.priority = UILayoutPriority(rawValue: 999)
                right.priority = UILayoutPriority(rawValue: 999)
                bottom.priority = UILayoutPriority(rawValue: 999)
                top.priority = UILayoutPriority(rawValue: 999)
                self.view.addConstraints([left, right, top, bottom])
            }
            
            layoutConstrained = true
        }
    }

    ///MARK: Text Management
    public override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    public override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        //var textToTranslate = getProperTextFrom(textInput)
        if textDocument.text() == "" {
            autoShifted = true
        }
    }
    
    ///MARK: Key Actions
    public func keyPressed(key: KeyboardKeyView) {
        UIDevice.current.playInputClick()
        spaceWaiting = false
        
        if let text = key.outputText {
            if key.shifted {
                textDocument.insertText(text: text.uppercased())
            } else {
                textDocument.insertText(text: text.lowercased())
            }
        }
        
        if autoShifted {
            keyboardView.setShift(shift: false)
            autoShifted = false
        }
    }
    
    public func specialKeyPressed(key:KeyboardKeyView) {
        
    }
    
    /** 
     Default action is to delete the last character.
     */
    public func backspaceKeyPressed(key: KeyboardKeyView) {
        UIDevice.current.playInputClick()
        spaceWaiting = false

        textDocument.deleteBackward()
        
        let char = textDocument.lastCharacter()
        
        if char == nil {
            self.autoShifted = true
            self.keyboardView.setShift(shift: true)
        }
        else if char != " " {
            self.autoShifted = false
            self.keyboardView.setShift(shift: false)
        }
    }
    
    /**
     Default action is to insert one blank "space" character.
    */
    public func spaceKeyPressed(key: KeyboardKeyView) {
        UIDevice.current.playInputClick()

        if let lastChar = textDocument.lastCharacter() {
            if ["!", "?", "."].contains(lastChar) {
                autoShifted = true
                keyboardView.setShift(shift: true)
            } else if !spaceWaiting {
                spaceWaiting = true
            } else if lastChar == " " {
                textDocument.deleteBackward()
                textDocument.insertText(text: ".")
                autoShifted = true
                keyboardView.setShift(shift: true)
            }
        }
        
        if self.mode != .Alphabet {
            self.mode = .Alphabet
            self.keyboardView.reloadKeys()
        }
        textDocument.insertText(text: " ")
    }
    
    public func shiftKeyPressed(key: KeyboardKeyView) {
        UIDevice.current.playInputClick()
        
        keyboardView.toggleShift()
        self.autoShifted = !self.autoShifted
    }
    
    public func returnKeyPressed(key: KeyboardKeyView) {
        UIDevice.current.playInputClick()

        textDocument.insertText(text: "\n")
    }
    
    public func modeChangeKeyPressed(key: KeyboardKeyView) {
        UIDevice.current.playInputClick()
        if self.mode == .Alphabet {
            self.mode = .NumberSymbols1
        } else if self.mode == .NumberSymbols1 || self.mode == .NumberSymbols2 {
            self.mode = .Alphabet
        }
        
        self.keyboardView.reloadKeys()
    }
    
    public func nextKeyboardKeyPressed(key: KeyboardKeyView) {
        UIDevice.current.playInputClick()

        self.advanceToNextInputMode()
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
}
