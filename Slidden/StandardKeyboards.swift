//
//  KeyboardLanguage.swift
//  Trype
//
//  Created by Daniel Brim on 9/4/14.
//  Copyright (c) 2014 db. All rights reserved.
//

import UIKit

public enum KeyboardLanguage: String {
    case English_US = "en-US"
}

private let englishUSKeys = [["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
                             ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
                             ["Z", "X", "C", "V", "B", "N", "M"]]

public class StandardKeyboard {
    
    public class func standardKeyboardFor(language: KeyboardLanguage) -> KeyboardView? {
        switch language {
            
        case .English_US:
            let keyboard = KeyboardView()
            for (_, row) in englishUSKeys.enumerated() {
                for key in row {
                    _ = KeyboardKeyView(type: .Character, keyCap: key, outputText: key)
                }
            }
            print("Returning the default English US keyboard")
            return keyboard
            
            //        default:
            //            print("This option is unsupported")
            //        }
//            return nil
        }
        
        //    public class func keyboardKeyForType(type: KeyboardKeyView.Type) -> KeyboardKeyView {
        //
        ////        switch type {
        ////            case .Shift
        ////        }
        ////        keyboardKey.image = img
        ////        keyboardKey.imageView.contentMode = .Center
        //    }
    }
}
