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
        
        // MARK: - Breakpoints
        for i in 1 ... 100 {
            print("Got number \(i)") // Click in the gutter to add a breakpoint! Code will stop can be inspected in debugger
        }
        
        
        // F6 (or Fn+F6 if keyboard F6 is mapped to something by default) -> stepover and continue to next line
        // Ctrl+Cmd+Y -> Continue to execture programming until another breakpoint hit
        // To the left window of xcode is a backtrace, which will say where bug occurred
        // (i.e. bug in func d() which was called by c() in turn by b() in turn by a()
        
        // Bottom window of xcode gives an interactive LLDB debugger window.
        // Commands can be typed to query values and run methods.
        // for example; to print the value of parameter i, type "p i"
        
        // Breakpoints have two other awesome features:
        //  1. They can be conditional (right-click brkpoint, edit, condition value)
        //      i.e. i % 10 == 0 above to stop every 10 iters
        //  Conditional break points can in turn be used to 'automatically continue' from the condition (set in same place)
        //  2. They can be automatically triggered when an exception is thrown
        //      Exception = errors that aren't handled
        //      Brkpoints can be used to say, if error thrown, pause execution
        //      To enable, Cmd+8 (breakpoint navigatior) -> + button in buttom left, choose exception breakpoint
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

