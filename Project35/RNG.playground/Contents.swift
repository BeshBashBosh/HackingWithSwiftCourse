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


// MARK: - Deterministic GKRandomSource

// As noted above, since GKRandomSource() is not deterministic (cannot determine its output), it is not possible to use it for synchronising states over a
// network. For example, if a game had a feature related to RNG in die rolls, if they didn't get what they wanted, they could quit app and roll again, thus
// being able to easily cheat.

// GameplayKit has three ways of generating deterministic random values
// Why 3? Such form of RNG is difficult, so have options for:
//      1) Simple and fast - GKLinearCongruentialRandomSource - high performance, low randomness
//      2) Complex and slow - GKMersenneTwisterRandomSource - low performance, high randomness
//      3) a middle between 1+2 - GKARC4RandomSource - good performance, good randomness
// In reality, unless generating vast quantities of random numbers all above have similar performance

// Examples:
let arc4 = GKARC4RandomSource()
print(arc4.nextInt(upperBound: 20))

let mersenne = GKMersenneTwisterRandomSource()
print(mersenne.nextInt(upperBound: 20))

// NOTE: APPLE RECOMMENDS FORCE FLUSHING ARC4 RNG BEFORE USING FOR ANYTHING IMPORTANT OTHERWISE IT GENERATES PREDICTABLE SEQUENCES.
//       API GUIDELINES SUGGEST DROPPING AT LEAST THE FIRST 769 VALUES. MOST ROUND TO MORE PLEASING VALUE OF 1024. e.g.
arc4.dropValues(1024)

// IMPORTANT NOT: APPLE STILL RECOMMENDS NOT USING THIS FOR CRYPTOGRAPHIC PURPOSES.


// MARK: - Gameplay Kit Random distributions

// Say we wanted to simulate random rolls of a 6-sided die, could use RandomInt(min:max:) method above.
// BUT... GK defines random distributions that each have a 6-sided die built-in to the API, e.g.

let d6 = GKRandomDistribution.d6()
print(d6.nextInt())

// ... or even a 20 sided device
let d20 = GKRandomDistribution.d20()
print(d20.nextInt())

//... or a 11,539(!!!) sided die...
let crazyDie = GKRandomDistribution(lowestValue: 1, highestValue: 11539)
print(crazyDie.nextInt())

// so technically the last one has nothing to do with a dice but more a distribution of random values
// Care must be taken with the .nextInt(upperBound:) class method on a bounded distribution as it will crash code if upperBound is outside of the
// defined distributions highestValue.

// Can set the random source type of distro with:
let rand = GKMersenneTwisterRandomSource()
let distribution = GKRandomDistribution(randomSource: rand, lowestValue: 10, highestValue: 20)
print(distribution.nextInt())

// GK also provides two other distributions
//     1) GKShuffledDistribution - ensures sequences repeat less often (anti-clustering distro)
//                               - Will cycle through every unique value before repeating
//     2) GKGaussianDistribution - ensures results naturally form a bell curve with results near to the mean occurring more frequently
// e.g.

let shuffled = GKShuffledDistribution.d6()
print(shuffled.nextInt())
print(shuffled.nextInt())
print(shuffled.nextInt())
print(shuffled.nextInt())
print(shuffled.nextInt())
print(shuffled.nextInt())
print(shuffled.nextInt())

let gauss = GKGaussianDistribution(randomSource: mersenne, mean: 5, deviation: 2)
print(gauss.nextInt())
print(gauss.nextInt())
print(gauss.nextInt())
print(gauss.nextInt())
print(gauss.nextInt())
print(gauss.nextInt())

// MARK: - Randomised Shuffling
// Many apps will implement the Fisher-Yates shuffle extension to Arrays by Nate Cook:
extension Array {
    mutating func shuffle() {
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            swapAt(i, j)
        }
    }
}

var lotteryBalls = [Int](1...49)
lotteryBalls.shuffle()

// GK offers a similar version. The difference is that it does not shuffle in place
let lottoBalls = [Int](1...49)
let shuffledBalls = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: lottoBalls)

// You could cheat at this lottery by making it deterministic and seeding it...
let fixedLotteryBalls = [Int](1...49)
let fixedShuffledBalls = GKMersenneTwisterRandomSource(seed: 1001).arrayByShufflingObjects(in: fixedLotteryBalls)
// this will maked fixedShuffledBalls be the same each time (so long as seed doesn't change).


























