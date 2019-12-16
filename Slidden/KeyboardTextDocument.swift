//
//  TextDocument.swift
//  Trype
//
//  Created by Daniel Brim on 9/7/14.
//  Copyright (c) 2014 db. All rights reserved.
//

import UIKit

public class KeyboardTextDocument: NSObject {
    
    public var textDocumentProxy: UITextDocumentProxy!
    
    public init(proxy: UITextDocumentProxy) {
        super.init()
        self.textDocumentProxy = proxy
    }

    public func insertText(text: String) {
        textDocumentProxy.insertText(text)
    }
    
    public func deleteBackward() -> Character? {
        let lastChar: Character? = lastCharacter()
        
        textDocumentProxy.deleteBackward()
        return lastChar
    }
    
    public func lastCharacter() -> Character? {
        return text()?.lastCharacter()
    }
    
    public func text() -> String? {
        var text: String = String()
        if let before = textDocumentProxy.documentContextBeforeInput {
            text += before
        }
        if let _ = textDocumentProxy.documentContextAfterInput {
//            text += after
        }
        return text
    }
    
    public func selectedText() -> String? {
        
        _ = textDocumentProxy
//        input.textInRange(<#range: UITextRange#>)
        
        return nil
    }
    
    public func sentences() -> [String]? {
        if let txt = text() {
            return txt.sentencesArray
        }
        return nil
    }
    
    public func words() -> [String]? {
        if let txt = text() {
            return txt.wordArray
        }
        return nil
    }
    
    public func lastSentence() -> String? {
        
        if let sentences = sentences() {
            if sentences.count > 0 {
                return sentences[sentences.count - 1]
            }
        }
        
        return nil
    }
    
    public func deleteAllText() {
        if let text = self.text() {
            for _ in text {
                self.textDocumentProxy.deleteBackward()
            }
        }
    }
    
    public func deleteTextInRange(range: Range<Int>) {
        if var txt = self.text() {
            let convertedRange: ClosedRange<String.Index> = txt.convertRange(range: range)
            txt.removeSubrange(convertedRange)
            for _ in txt {
                self.textDocumentProxy.deleteBackward()
            }
            self.textDocumentProxy.insertText(txt)
        }
    }
    
    public func insertTextAtPosition(text: String, position: UInt) {
        _ = "Here is a short sentence"
//        testing.insert(newElement: "D", atIndex: 0)
    }
    
//    public func rangeOfText(text: String) -> Range<Int> {
//        
//    }
}

extension String {
    public func convertRange(range: Range<Int>) -> ClosedRange<String.Index> {
        let startIndex = self.index(self.startIndex, offsetBy: range.startIndex)
        let endIndex = self.index(startIndex, offsetBy: range.endIndex - range.startIndex)
        return startIndex...endIndex
    }
}

extension String {
    
    public var sentencesArray: [String] {
        var sentences = [String]()
        let optionalRange = self.range(of: self)
            if let range = optionalRange {
                self.enumerateSubstrings(in: range, options: NSString.EnumerationOptions.bySentences) { (substring, substringRange, enclosingRange, stop) -> () in
                    sentences.append(substring!)
                }
            }
            
            return sentences
    }
    
    public var wordArray: [String] {
        var words = [String]()
        let optionalRange = self.range(of: self)
            if let range = optionalRange {
                self.enumerateSubstrings(in: range, options: NSString.EnumerationOptions.byWords) { (substring, substringRange, enclosingRange, stop) -> () in
                    words.append(substring!)
                }
            }
            
            return words
    }
    
    public func lastCharacter() -> Character? {
        var lastChar: Character?
    
        let length = self.count
        if length > 1 {
            let lastCharIndex = self.index(self.endIndex, offsetBy: -1)
            lastChar = self[lastCharIndex]
        } else if length == 1 {
            lastChar = Character(self)
        }
        return lastChar
    }
}
