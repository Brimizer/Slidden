//
//  KeyView.swift
//  Trype
//
//  Created by Daniel Brim on 9/3/14.
//  Copyright (c) 2014 db. All rights reserved.
//

import UIKit

public class KeyboardKeyView: UIControl {
    public enum KeyType {
        case Character
        case SpecialCharacter
        case Shift
        case Backspace
        case ModeChange
        case KeyboardChange
        case Period
        case Space
        case Return
        case None
    }
    
    public var type: KeyType! {
        willSet {
            setupType(newValue)
        }
    }
    public var keyCap: String? {
        didSet {
            self.redrawText()
        }
    }

    public var outputText: String?
    public var color: UIColor? {
        didSet {
            self.backgroundColor = color
        }
    }
    
    public var textColor: UIColor? {
        didSet {
            recolor()
        }
    }
    
    public var selectedColor: UIColor?
    
    public var shouldColorImage: Bool = false {
        didSet {
            recolor()
        }
    }
    
    /// If image is set, the key will display the image instead of the keyCap
    public var image: UIImage? {
        didSet {
            redrawImage()
        }
    }
    
    public var imageView: UIImageView = UIImageView()
    
    var contentInset: UIEdgeInsets?
    var borderColor: UIColor?
    var borderRadius: Float?
    
    private var internalView = UIView() // Unused
    private var textLabel = UILabel()
    private var layoutConstrained: Bool = false
    
    ///MARK: Setup
    public override init() {
        super.init()
    }
    
    public override init(frame: CGRect) {
        self.type = .None
        
        super.init(frame: frame)
        
        setup()
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public convenience init(type: KeyType, keyCap: String, outputText: String) {
        self.init()
        
        self.type = type
        self.outputText = outputText
        self.keyCap = keyCap
        
        setup()
    }
    
    func setup() {
        self.addTarget(self, action: "pressed", forControlEvents: .TouchDown)
        self.addTarget(self, action: "depressed", forControlEvents: .TouchUpInside)
        self.addTarget(self, action: "cancelled", forControlEvents: .TouchUpOutside)
        self.addTarget(self, action: "cancelled", forControlEvents: .TouchCancel)
        self.addTarget(self, action: "cancelled", forControlEvents: .TouchDragExit)

        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.internalView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.textLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        setupDefaultLabel()
        redrawText()
    }
    
    private func setupDefaultLabel() {
        //        self.textLabel.backgroundColor = UIColor.whiteColor()
        self.textLabel.textAlignment = .Center
        self.textLabel.textColor = UIColor.whiteColor()
        self.textLabel.font = UIFont(name: "HelveticaNeue-Light", size: 22.0)
        self.addSubview(self.textLabel)
    }
    
    private func setupType(type: KeyType) {
//        if (self.image != nil) {
//            return
//        }
//        
//        switch type {
//        case .Shift:
//            self.image = UIImage(named: "Shift")
//        case .KeyboardChange:
//            self.image = UIImage(named: "NextKeyboard")
//        default:
//            self.image = nil
//        }
    }
    
    ///MARK: Layout
    public override func updateConstraints() {
        super.updateConstraints()
        
        if !layoutConstrained {
            
            // Layout label's constraints
            self.addConstraints(self.constraintsForContentView(textLabel))
            
            layoutConstrained = true
        }
    }
    
    private func constraintsForContentView(view: UIView) -> [NSLayoutConstraint] {
        var ret: [NSLayoutConstraint] = []
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        var top: CGFloat = 0.0
        var left: CGFloat = 0.0
        var bottom: CGFloat = 0.0
        var right: CGFloat = 0.0
        
        if let insets = contentInset {
            top = insets.top
            left = insets.left
            bottom = insets.bottom
            right = insets.right
        }
        
        let leftC = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: left)
        let topC = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: top)
        let rightC = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -bottom)
        let bottomC = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -right)
        
        ret += [leftC, topC, rightC, bottomC]
        
        return ret
    }
    
    func depressed() {
        self.backgroundColor = color
    }
    
    func cancelled() {
        self.backgroundColor = color
    }    
    
    func pressed() {
        self.backgroundColor = selectedColor
    }
    
    ///MARK: Text Management
    func redrawText() {
        if let cap = self.keyCap {
            self.textLabel.text = cap
        } else {
            self.textLabel.text = ""
        }
    }
    
    private func redrawImage() {
        let endImage = (self.shouldColorImage) ? recolorImage(image?, color: textColor?) : image?
        
        if let img = endImage {
            self.imageView.image = img
            self.textLabel.hidden = true
            self.addSubview(self.imageView)
            self.addConstraints(constraintsForContentView(self.imageView))
            self.setNeedsUpdateConstraints()
        } else {
            self.imageView.removeConstraints(self.imageView.constraints())
            self.textLabel.hidden = false
            self.setNeedsUpdateConstraints()
        }
    }
    
    private func recolor() {
        if let img = self.image {
            if self.shouldColorImage {
                if let newcolor = textColor {
                    self.imageView.image = recolorImage(img, color: newcolor)
                }
            }
        }
    }
    
    private func recolorImage(image: UIImage?, color: UIColor?) -> UIImage? {
        if let img = image {
            if let col = color {
                let rect = CGRectMake(0, 0, img.size.width, img.size.height)
                UIGraphicsBeginImageContext(rect.size);
                let context = UIGraphicsGetCurrentContext()
                CGContextClipToMask(context, rect, img.CGImage)
                CGContextSetFillColorWithColor(context, col.CGColor)
                CGContextFillRect(context, rect)
                let temp = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                let oriented = UIImage(CGImage: temp.CGImage, scale: 1.0, orientation:UIImageOrientation.DownMirrored)
                
                return oriented
            }
        }
        return nil
    }
}
