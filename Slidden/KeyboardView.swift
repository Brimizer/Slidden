//
//  KeyboardView.swift
//  Trype
//
//  Created by Daniel Brim on 9/3/14.
//  Copyright (c) 2014 db. All rights reserved.
//

import UIKit

protocol KeyboardViewDelegate {
    func keyPressed(key: KeyboardKeyView)
    func backspaceKeyPressed(key: KeyboardKeyView)
    func spaceKeyPressed(key: KeyboardKeyView)
    func shiftKeyPressed(key: KeyboardKeyView)
    func returnKeyPressed(key: KeyboardKeyView)
    func modeChangeKeyPressed(key: KeyboardKeyView)
    func nextKeyboardKeyPressed(key: KeyboardKeyView)
}

public class KeyboardView: UIView {
    
    var color: UIColor?
    /// If no background image is present, uses background color
    var image: UIImage?
    var keyRows: Array<Array<KeyboardKeyView>>!
    var currentLanguage: KeyboardLanguage!
    
    var delegate: KeyboardViewDelegate?
    
    private var layoutConstrained: Bool = false
    
    ///MARK: Setup
    override init() {
        super.init()
        setup()
    }
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        keyRows = Array<Array<KeyboardKeyView>>()
        self.currentLanguage = KeyboardLanguage.English_US
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.setNeedsUpdateConstraints()
    }
    
    ///MARK: Layout
    override public func updateConstraints() {
        super.updateConstraints()
        
        if !layoutConstrained {
            var lastRowView: UIView? = nil
            for (rowIndex, keyRow) in enumerate(keyRows) {
                var lastKeyView: UIView? = nil
                for (keyIndex, key) in enumerate(keyRow) {
                    
                    key.setTranslatesAutoresizingMaskIntoConstraints(false)
                    
                    var relativeWidth: CGFloat = 0.0;
                    switch key.type! {
                    case .ModeChange:
                        relativeWidth = 1/8
                    case .KeyboardChange:
                        relativeWidth = 1/8
                    case .Space:
                        relativeWidth = 3/8
                    case .Return:
                        relativeWidth = 2/8
                    case .Translate:
                        relativeWidth = 1/8
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
    
    public func addKey(key: KeyboardKeyView, row: Int) {
        key.addTarget(self, action: "keyPressed:", forControlEvents: .TouchUpInside)
        if keyRows.count <= row {
            for i in self.keyRows.count...row {
                keyRows.append(Array<KeyboardKeyView>())
            }
        }
        if let cap = key.keyCap {
            println("Adding key: \(key.keyCap!)")
        }
        keyRows[row].append(key)
        addSubview(key)
    }
    
    func keyPressed(sender: AnyObject!) {
        if let key: KeyboardKeyView = sender as? KeyboardKeyView {
            if let type = key.type {
                switch type {
                case .Character:
                    delegate?.keyPressed(key)
                case .SpecialCharacter:
                    delegate?.keyPressed(key)
                case .Shift:
                    delegate?.shiftKeyPressed(key)
                case .Backspace:
                    delegate?.backspaceKeyPressed(key)
                case .ModeChange:
                    delegate?.modeChangeKeyPressed(key)
                case .KeyboardChange:
                    delegate?.nextKeyboardKeyPressed(key)
                case .Return:
                    delegate?.returnKeyPressed(key)
                case .Space:
                    delegate?.spaceKeyPressed(key)
                default:
                    delegate?.keyPressed(key)
                }
            }
        }
    }
    
    private func constraintsForKey(key: KeyboardKeyView, lastKeyView: KeyboardKeyView, lastRowView: KeyboardKeyView) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        
        return constraints
    }
}
