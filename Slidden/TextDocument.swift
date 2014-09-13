//
//  TextDocument.swift
//  Trype
//
//  Created by Daniel Brim on 9/7/14.
//  Copyright (c) 2014 db. All rights reserved.
//

import UIKit

public class TextDocument: NSObject {
    
    public var textDocumentProxy: UITextDocumentProxy!
    
    public init(proxy: UITextDocumentProxy) {
        super.init()
        self.textDocumentProxy = proxy
    }
    
    public func insertText(text: String) {
        textDocumentProxy.insertText(text)
    }
    
    public func deleteBackward() {
        textDocumentProxy.deleteBackward()
    }
    
    public func text() -> String {
        var text = ""
        if let before = textDocumentProxy.documentContextBeforeInput {
            text += before
        }
        if let after = textDocumentProxy.documentContextAfterInput {
            text += after
        }
        return text
    }
    
    public func deleteAllText() {
        for i in self.text() {
            self.textDocumentProxy.deleteBackward()
        }
    }
    
    public func deleteTextInRange(range: Range<Int>) {
        var txt = self.text()
        let convertedRange: Range<String.Index> = txt.convertRange(range)
        txt.removeRange(convertedRange)
        for i in self.text() {
            self.textDocumentProxy.deleteBackward()
        }
        self.textDocumentProxy.insertText(txt)
    }
    
    public func insertTextAtPosition(text: String, position: UInt) {
        var testing = "Here is a short sentence"
//        testing.insert(newElement: "D", atIndex: 0)
    }
    
//    public func rangeOfText(text: String) -> Range<Int> {
//        
//    }
}

extension String {
    public func convertRange(range: Range<Int>) -> Range<String.Index> {
        let startIndex = advance(self.startIndex, range.startIndex)
        let endIndex = advance(startIndex, range.endIndex - range.startIndex)
        return Range<String.Index>(start: startIndex, end: endIndex)
    }
}
