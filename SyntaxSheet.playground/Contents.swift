
//: Playground - noun: a place where people can play
//: Course - Hacking With Swift
//: Author - B. E. S. Hall

import UIKit

// =====================
// Variables & Constants
// =====================

// A constant
let constant: String = "A constant"
// constant = 3 // error: cannot assign to value: 'constant' is a 'let' constant

// A Variable
var variable: String = "A variable"
variable = "New Variable"

// =====================
// Data Types
// =====================

// String
let string: String = "A string"

// Int
let int: Int = 1

// Float/Double
let float: Float = 1.0
let double: Double = 1.0 // Swift defaults to a double with type inference

// Boolean
let bool: Bool = false // or true

// Optional
var optional: String? = nil // or any <type>?

// =====================
// Operators
// =====================

// Mathematical operators
// +, -, *, /

// Assignment
// =, +=, -=, *=, /=

// Equality
// ==, !=, >, >=, <, <=

// =====================
// String Interpolation
// =====================
let strInterp: String = "Hello"
let TATLTUAE: Int = 42
let fish: Any = "fish!"
print("\(strInterp) World!\nThe answer to life, the universe, and everything is \(TATLTUAE)\nThanks for all the \(fish)")

// Can also concatenate Strings with + operator

// =====================
// Collections
// =====================

// ARRAYS
// Creation
var dblArr = [Double]() // or var dblArr: [Double] = []
dblArr = [1.0,2.0,3.0,4.0]
// let arr = [<Type>](); arr = [<Type>, <Type>, <Type>, ...]; // or use type inference off the bat with arr = [<Type>, <Type>, <Type>, ...]
// Can access and edit individual elemnets with
dblArr[0] = 10

// also default values
var defaultDblArr = Array(repeating: 0.0, count: 3)
var defulatStrArr = Array(repeating: "Spam", count: 10)

// Can APPEND (MUST BE SAME TYPE) via concatenation
var dblArr2 = dblArr + [5,6,7,8]
// or in place
dblArr += [5,6,7,8]
// or type method
dblArr.append(5) //... for single addition
dblArr.append(contentsOf: [6,7,8]) //... for a sequence

// And all similar remove methods
dblArr.remove(at: 0) // remove at index position. This also returns the removed value
// Also have .removeAll(), removeFirst(), removeLast(), removeSuberange(bounds: Range<Int>) type methods plus many more!

// Can replace part of array
dblArr.replaceSubrange(0...2, with: [10,11,12])
// Can get the <Type> of the array with
type(of: dblArr)

// Size of collection
var cnt: Int = dblArr.count

// DICTIONARIES - Hashable key-value
var personDict: [String: Any] = [
    "title": "Dr",
    "first": "Ben",
    "last": "Hall",
    "age": 27
            ]

let hadBirthday = true
if hadBirthday { personDict["age"] = 28 }

// Can get keys of dictionary with
let dictKeys = Array(personDict.keys)

// As with arrays, there are many Type methods for dictionaries for manipulating the elements.


print("Done")

