//
//  KeyView.swift
//  Trype
//
//  Created by Daniel Brim on 9/3/14.
//  Copyright (c) 2014 db. All rights reserved.
//

import UIKit

let keyFont = UIFont(name: "HelveticaNeue", size: 22.0)

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
            setupType(type: newValue)
        }
    }
    public var keyCap: String? {
        didSet {
            self.redrawText()
        }
    }

    public var outputText: String?
    
    public var shifted: Bool = false {
        willSet(newShifted) {
            if newShifted {
                self.textLabel.text = keyCap?.uppercased()
            } else {
                self.textLabel.text = keyCap?.lowercased()
            }
        }
    }
    
    public var color: UIColor? {
        didSet {
            self.backgroundColor = color
        }
    }
    
    public var textColor: UIColor? {
        didSet {
            self.textLabel.textColor = textColor!
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
    public var textLabel = UILabel()
    private var layoutConstrained: Bool = false
    
    ///MARK: Setup
    convenience init() {
        self.init(frame: .zero)
        self.type = .None
        setup()
    }
    
    public override init(frame: CGRect) {
        self.type = .None
        
        super.init(frame: frame)
        
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
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
        self.addTarget(self, action: #selector(pressed), for: .touchDown)
        self.addTarget(self, action: #selector(depressed), for: .touchUpInside)
        self.addTarget(self, action: #selector(cancelled), for: .touchUpOutside)
        self.addTarget(self, action: #selector(cancelled), for: .touchCancel)
        self.addTarget(self, action: #selector(cancelled), for: .touchDragExit)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.internalView.translatesAutoresizingMaskIntoConstraints = false
        self.textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        setupDefaultLabel()
        redrawText()
    }
    
    private func setupDefaultLabel() {
        //        self.textLabel.backgroundColor = UIColor.whiteColor()
        self.textLabel.textAlignment = .center
        self.textLabel.textColor = UIColor.white
        self.textLabel.font = keyFont
        self.textLabel.adjustsFontSizeToFitWidth = true
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
            self.addConstraints(self.constraintsForContentView(view: textLabel))
            
            layoutConstrained = true
        }
    }
    
    private func constraintsForContentView(view: UIView) -> [NSLayoutConstraint] {
        var ret: [NSLayoutConstraint] = []
        view.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        let leftC = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1.0, constant: left)
        let topC = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: top)
        let rightC = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1.0, constant: -bottom)
        let bottomC = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: -right)
        
        ret += [leftC, topC, rightC, bottomC]
        
        return ret
    }
    
    @objc func depressed() {
        self.backgroundColor = color
    }
    
    @objc func cancelled() {
        self.backgroundColor = color
    }    
    
    @objc func pressed() {
        if selectedColor != nil {
            self.backgroundColor = selectedColor
        }
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
        _ = (self.shouldColorImage) ? recolorImage(image: image, color: textColor) : image
        
//        if let img = endImage {
//            self.imageView.image = img
//            self.textLabel.hidden = true
//            self.addSubview(self.imageView)
//            self.imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
//            self.addConstraints(constraintsForContentView(self.imageView))
//            self.setNeedsUpdateConstraints()
//        } else {
//            self.imageView.removeConstraints(self.imageView.constraints())
//            self.textLabel.hidden = false
//            self.setNeedsUpdateConstraints()
//        }
    }
    
    private func recolor() {
        if let img = self.image {
            if self.shouldColorImage {
                if let newcolor = textColor {
                    self.imageView.image = recolorImage(image: img, color: newcolor)
                }
            }
        }
    }
    
    private func recolorImage(image: UIImage?, color: UIColor?) -> UIImage? {
        if let img = image {
            if let col = color {
                let rect = CGRect(x: 0, y: 0, width: img.size.width*5, height: img.size.height*5)
                UIGraphicsBeginImageContext(rect.size);
                let context = UIGraphicsGetCurrentContext()
                context?.clip(to: rect, mask: img.cgImage!)
                context!.setFillColor(col.cgColor)
                context!.fill(rect)
                let temp = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                let oriented = UIImage(cgImage: (temp?.cgImage!)!, scale: 5.0, orientation:UIImage.Orientation.downMirrored)
                
                return oriented
            }
        }
        return nil
    }
}
