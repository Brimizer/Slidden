
![Slidden: An open source, customizable, iOS 8 keyboard written in Swift.](https://github.com/Brimizer/Slidden/blob/master/assets/slidden.png)

Slidden is an open source, customizable, iOS 8 keyboard, written in Swift.
iOS 8 brought us the ability to create fully customizable keyboards, but does not provide a strong foundation to start from. 
Slidden aims to remedy that by providing an easy way to get started making your own iOS keyboards. 

> Slidden is named after the [Sholes and Glidden typewriter](http://en.wikipedia.org/wiki/Sholes_and_Glidden_typewriter), the first commercially successful typewriter and the origin of the QWERTY keyboard.

## Notice
Slidden is in its early stages of life. Code will change dramatically between updates. 
Please consider contributing your ideas if you think something is missing!

## Requirements
- Xcode 6
- iOS 8.0+

## Installation
At the current moment, the best installation method is to add Slidden as a git submodule and add `Slidden.framework` to your list of Target Dependencies. 
_Don't forget to add `Slidden.framework` to your keyboard's list of target dependencies as well!_

---

## Usage

### Simple

If you subclass Slidden.KeyboardViewController, you get a `KeyboardView` and nice autolayout constraints right out of the box. Subclasses is as easy as:

```swift
class KeyboardViewController: Slidden.KeyboardViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add the keys we need to the keyboard
        setupKeys()
    }
```

You can add keys to the keyboard like this:
```swift
func setupKeysSimple() {
        let helloKey = KeyboardKeyView(type: .Character, keyCap: "Hello", outputText: "Hello")
        helloKey.textColor = UIColor.whiteColor()
        helloKey.color = UIColor.blueColor()
        self.keyboardView.addKey(helloKey, row: 0)
        
        let worldKey = KeyboardKeyView(type: .Character, keyCap: "World", outputText: "World")
        worldKey.textColor = UIColor.whiteColor()
        worldKey.color = UIColor.redColor()
        self.keyboardView.addKey(worldKey, row: 0)
}
```

### Complex
_More Coming Soon_

### Creator

- [Daniel Brim](http://github.com/brimizer) ([@brimizer](https://twitter.com/brimizer))

## License

Slidden is released under an MIT license. See LICENSE for more information.
