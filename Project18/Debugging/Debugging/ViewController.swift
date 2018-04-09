//
//  ViewController.swift
//  Debugging
//
//  Created by Ben Hall on 09/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // MARK: - Debug with print
        print("The simplest way to track a program in to use the 'print()' method")
        print("This method prints to the console. For example, Hi from the viewDidLoad() method!")
        print("Often this isn't the best way to debug though...")
        
        // But print is quite versatile:
        print(1, 2, 3, 4, 5) // Printing multiple parameters - print is a variadic funtion that accepts any number of pars
        print(1, 2, 3, 4, 5, separator: "-") // Can provide a string the separates the printing of the variadic inputs
        print("Some message", terminator: "") // Can also specify how the line is terminated (defuault line breaks character \n)
        
        // MARK: - Assertions
        // These debug-only checks force the app to crash if the required condition is not met
        // When the app is shipped to the App Store, xcode automatically disables the assertions
        assert(1 == 1, "Maths failure!")
        //assert(1 == 2, "Maths failure!") // this will crash and display the message input as the second parameter
        // Function calls can also be used in the assert(mySlowMethod() == true, "#oops crashed")
        // These are better than print because they will be completely negated in production code whereas print is technically
        // still run in production code.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

