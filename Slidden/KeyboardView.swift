
//
//  KeyboardView.swift
//  Trype
//
//  Created by Daniel Brim on 9/3/14.
//  Copyright (c) 2014 db. All rights reserved.
//

import UIKit

public protocol KeyboardViewDatasource {
    func numberOfRowsInKeyboardView(keyboardView: KeyboardView) -> Int
    func keyboardView(keyboardView: KeyboardView, numberOfKeysInRow row:Int) -> Int
    func keyboardView(keyboardView: KeyboardView, keyAtIndexPath indexPath: NSIndexPath) -> KeyboardKeyView?
}

@objc
public protocol KeyboardViewDelegate {
    
    optional func keyPressed(key: KeyboardKeyView)
    optional func specialKeyPressed(key: KeyboardKeyView)
    optional func backspaceKeyPressed(key: KeyboardKeyView)
    optional func spaceKeyPressed(key: KeyboardKeyView)
    optional func shiftKeyPressed(key: KeyboardKeyView)
    optional func returnKeyPressed(key: KeyboardKeyView)
    optional func modeChangeKeyPressed(key: KeyboardKeyView)
    optional func nextKeyboardKeyPressed(key: KeyboardKeyView)
}

public class KeyboardView: UIView {

    var backgroundImage: UIImage?
    var currentLanguage: KeyboardLanguage!
    
    var datasource: KeyboardViewDatasource?
    var delegate: KeyboardViewDelegate?
    
    var keyRows: Array<Array<KeyboardKeyView>>!
    private var layoutConstrained: Bool = false
    
    ///MARK: Setup
    convenience init() {
        self.init(frame: CGRectZero)
        setup()
    }
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        keyRows = Array<Array<KeyboardKeyView>>()
        self.currentLanguage = KeyboardLanguage.English_US
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public func reloadKeys() {
        // Remove existing keys
        removeKeys()
        keyRows = Array<Array<KeyboardKeyView>>()
        
        if let numRows = datasource?.numberOfRowsInKeyboardView(self) {
            for rowIndex in 0..<numRows {
                if let numKeys = datasource?.keyboardView(self, numberOfKeysInRow: rowIndex) {
                    for keyIndex in 0..<numKeys {
                        if let keyView = datasource?.keyboardView(self, keyAtIndexPath: NSIndexPath(forItem: keyIndex, inSection: rowIndex)) {
                            addKey(keyView, row: rowIndex)
                        }
                    }
                }
            }
        }
        
        layoutConstrained = false
        self.setNeedsUpdateConstraints()
    }
    
    public func reloadKeyAtIndexpath(indexPath: NSIndexPath) {
        
    }
    
    ///MARK: Layout
    override public func updateConstraints() {
        super.updateConstraints()
        print("updating constraints in keyboardView")
        
        if !layoutConstrained {
            var lastRowView: UIView? = nil
            for (rowIndex, keyRow) in keyRows.enumerate() {
                var lastKeyView: UIView? = nil
                for (keyIndex, key) in keyRow.enumerate() {
                    
                    key.translatesAutoresizingMaskIntoConstraints = false
                    
                    var relativeWidth: CGFloat = 0.0;
                    switch key.type! {
                    case .ModeChange:
                        relativeWidth = 1/8
                    case .KeyboardChange:
                        relativeWidth = 1/8
                    case .Space:
                        relativeWidth = 4/8
                    case .Return:
                        relativeWidth = 2/8
                    default:
                        relativeWidth = 0.0
                    }
                    
                    if let lastView = lastKeyView {
                        let left = NSLayoutConstraint(item: key, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: lastView, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0.0)
                        let top = NSLayoutConstraint(item: key, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: lastView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0)
                        let bottom = NSLayoutConstraint(item: key, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: lastView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0)
                        var width: NSLayoutConstraint?
                        if relativeWidth == 0.0 {
                            width = NSLayoutConstraint(item: key, attribute: .Width, relatedBy: .Equal, toItem: lastView, attribute: .Width, multiplier: 1.0, constant: 0.0)
                        } else {
                            width = NSLayoutConstraint(item: key, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: relativeWidth, constant: 0.0)
                        }
                        
                        self.addConstraints([left, top, bottom, width!])
                    } else {
                        let leftEdge = NSLayoutConstraint(item: key, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0.0)
                        self.addConstraint(leftEdge)
                        
                        if let lastRow = lastRowView {
                            let top = NSLayoutConstraint(item: key, attribute: .Top, relatedBy:.Equal, toItem: lastRow, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
                            let height = NSLayoutConstraint(item: key, attribute: .Height, relatedBy: .Equal, toItem: lastRow, attribute: .Height, multiplier: 1.0, constant: 0.0)

                            self.addConstraints([top, height])
                        } else {
                            let topEdge =  NSLayoutConstraint(item: key, attribute: .Top, relatedBy:.Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0)
                            self.addConstraint(topEdge)
                        }
                        
                        if rowIndex == keyRows.count - 1 {
                            let bottomEdge = NSLayoutConstraint(item: key, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
                            self.addConstraint(bottomEdge)
                        }
                        lastRowView = key
                    }
                    
                    if keyIndex == keyRow.count - 1 {
                        let rightEdge = NSLayoutConstraint(item: key, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0.0)
                        self.addConstraint(rightEdge)
                    }
                    
                    lastKeyView = key
                }
            }
            layoutConstrained = true
        }
    }
    
    private func addKey(key: KeyboardKeyView, row: Int) {
        key.addTarget(self, action: "keyPressed:", forControlEvents: .TouchUpInside)
        if keyRows.count <= row {
            for _ in self.keyRows.count...row {
                keyRows.append(Array<KeyboardKeyView>())
            }
        }
        
        keyRows[row].append(key)
        addSubview(key)
    }
    
    ///MARK: Public
    public func setShift(shift: Bool) {
        for row in keyRows {
            for key in row {
                if key.type == KeyboardKeyView.KeyType.Character {
                    key.shifted = shift
                }
            }
        }

    }
    
    public func toggleShift() {
        for row in keyRows {
            for key in row {
                if key.type == KeyboardKeyView.KeyType.Character {
                    key.shifted = !key.shifted
                }
            }
        }
    }
    
    ///MARK: Private Helper Methods
    func keyPressed(sender: AnyObject!) {
        if let key: KeyboardKeyView = sender as? KeyboardKeyView {
            if let type = key.type {
                switch type {
                case .Character:
                    delegate?.keyPressed!(key)
                case .SpecialCharacter:
                    delegate?.specialKeyPressed!(key)
                case .Shift:
                    delegate?.shiftKeyPressed!(key)
                case .Backspace:
                    delegate?.backspaceKeyPressed!(key)
                case .ModeChange:
                    delegate?.modeChangeKeyPressed!(key)
                case .KeyboardChange:
                    delegate?.nextKeyboardKeyPressed!(key)
                case .Return:
                    delegate?.returnKeyPressed!(key)
                case .Space:
                    delegate?.spaceKeyPressed!(key)
                default:
                    delegate?.keyPressed!(key)
                }
            }
        }
    }
    
    private func constraintsForKey(key: KeyboardKeyView, lastKeyView: KeyboardKeyView, lastRowView: KeyboardKeyView) -> [NSLayoutConstraint] {
        let constraints: [NSLayoutConstraint] = []
        
        return constraints
    }
    
    private func removeKeys() {
        _ = [NSLayoutConstraint]()
        for row in keyRows {
            for key in row {
                if key.hasAmbiguousLayout() {
                    print(" *** Ambiguous layout: \(key) \n")
                }
                key.removeConstraints(key.constraints)
                key.removeFromSuperview()
            }
        }
    }
}
