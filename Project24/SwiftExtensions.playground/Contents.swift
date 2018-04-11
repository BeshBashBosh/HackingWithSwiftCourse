//: Playground - noun: a place where people can play

import UIKit

// MARK: - Basic Extensions
// Add functionality to the Int type, or ratherm EXTEND its functionality
extension Int {
    func returnPlusOne() -> Int {
        return self + 1 // self refers to the Int object that called this method
    }
    
    mutating func plusOne() { // mutating required to modify the actual value
        self += 1
    }
}

// Create an Int
var myInt = 0
// Use the extension like this...
myInt.returnPlusOne() // 1
// ... or directly like this!
5.returnPlusOne() // 6

// Or modfy the value itself
print(myInt) // 0
myInt.plusOne() // extension
print(myInt) // 1

// MARK: - Protocol Oriented Programming (POP) for beginners
// POP allows you to extend swathes of data types at the same time. An advanced topic covered in Pro Swift book.

// This extension to square an Int value specifically refers to Int types
extension Int {
    func squared() -> Int {
        return self * self
    }
}

// This will work
let i: Int = 8
print(i.squared())

// But there are other types of Int (namely, UInt, Int8 etc.).
// The extension above won't work on those types (despite the other Int varieties essentially being an Int)

// This extension fixes that
extension BinaryInteger { // BinaryInteger is a protocol applied to all the Int varieties
    func squared() -> Self { // The (capital S) 'Self' refers to "the current data type). So this returns whatever Type called it!
        return self * self // The lowercase 'self' refers to "the current value"
    }
}

let normInt: Int = 8
let unsignInt: UInt = 8
let intEight: Int8 = 8
print(normInt.squared())
print(unsignInt.squared())
print(intEight.squared()) // All of these now work!!

// Extensions work across all data types (even custom made ones!)
// Don't have to subclass to implement extensions and they can be located in different files
//      Files with extensions often named with the scheme "Type+Modifier.swift" (e.g. "String+RandomLetter.swift")
// Extensions can be used to add brevity to code (i.e. wrap around otherwise long named methods; String.trimmingCharacters(in:) could become String.trim() )

// Note, when extending Type, think whether extension would be better served as a property (e.g. computed) rather than a method
//      (Very) Generalized rule of thumb: methods should be verbs, whereas things that describe state (even after calculation) should be properties.

// IMPORTANT NOTE: EXTENSIONS CANNOT STORE ANY (non-computed) PROPERTIES





