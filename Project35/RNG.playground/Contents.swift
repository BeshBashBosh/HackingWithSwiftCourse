//: Playground - noun: a place where people can play

import UIKit
import GameplayKit

// MARK: - ARC4RANDOM
// Classical way of generating large, seemingly random numbers is with:
print(arc4random())
print(arc4random())
print(arc4random())
print(arc4random())

// arc4random generates numbers between 0 - 4,294,967,295 (up to 2^32 - 1)

// To use arc4random() to generate numbers within a range there are 2 ways people do it
// (1) The most common way
//  Modulo division
print(arc4random() % 6) // random val between 0 and 5

// the problem with this is "Modulo bias" (or Pgeonhole Principle) which is a phenomena that results in a
// small but not insignificant bias of some numbers being generated more commonly thatn others.

// (2) The proper way
print(arc4random_uniform(6))
// This type does not require seeding, can generate within a range without modulo bias, and are suitable random value for all but cypto purposes

// BUT, what if we want a lower range...

func RandomInt(min: Int, max: Int) -> Int {
    if max < min { return min }
    return Int(arc4random_uniform(UInt32((max - min) + 1))) + min
}

print(RandomInt(min: 20, max: 30))

// Sure the above works, but it's not very memorable... This is where GamePlayKit comes in (although this framework is not available in open-source swift)

// MARK: - GAMEPLAYKIT
// Most basic way of RNG with GameplayKit is using the GKRandomSource class and its sharedRandom() method:
print(GKRandomSource.sharedRandom().nextInt()) // between +/- 2,147,483,648

// a random source is an unfiltered stream of random numbers as you need them.
// Gives a very random state. Not overly useful for synchronising network games becyase everyones RandomSource will be in a different state.

// For use within an upper limit
print(GKRandomSource.sharedRandom().nextInt(upperBound: 6))

// Also have other random types e.g.,
print(GKRandomSource.sharedRandom().nextBool())


