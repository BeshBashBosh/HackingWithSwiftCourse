//
//  ViewController.swift
//  CoreGraphicsDraw
//
//  Created by Ben Hall on 13/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties
    var currentDrawType = 0 // This will be used to cycle through CoreGraphics
    
    // MARK: - Custom methods
    // Example of drawing a rectangle
    func drawRectangle() {
        // Create a renderer
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        // call renderer image() method with closure which passes in a
        // reference to the UIGraphicsImageRendererContext as the ctx parameter
        let img = renderer.image { ctx in
            // drawing code
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor) // set the fill colour of the rectangle
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor) // set the stroke (edge) colour of rect
            ctx.cgContext.setLineWidth(10) // set the stroke/edgewidth of the stroke
            
            ctx.cgContext.addRect(rectangle) // add the rectangle
            ctx.cgContext.drawPath(using: .fillStroke) // draw the rectangles path
        }
        
        imageView.image = img
    }
    
    // Example of drawing a circle
    func drawCircle() {
        // Circles and ellipses are drawn within the bounds of a specified rectangle
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            let rectangle = CGRect(x: 5, y: 5, width: 502, height: 502) // Made smaller than the renderer to take into account edge line width
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
            
        }
        
        imageView.image = img
    }
    
    // Example of drawing a checkerboard
    func drawCheckerboard() {
        // Note: Can actually make checkerboards using a Core Image filter CICheckerboardGenerator
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            
            for row in 0 ..< 8 {
                for col in 0 ..< 8 {
                    if (row + col) % 2 == 0 {
                        ctx.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
                    }
                }
            }
        }
        
        imageView.image = img
    }
    
    // Example of applying transforms to CM context prior to drawing
    func drawRotatedSquares() {
        // Unlike CGAffineTransform, which rotates views about their center, cgContext transformations
        // happen about top left corner of graphic. Can use cgContext.translateBy() to simulate
        // moving the point we rotate about.
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            let rotations = 16
            let amount = Double.pi / Double(rotations)
            
            for _ in 0 ..< rotations {
                ctx.cgContext.rotate(by: CGFloat(amount))
                ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
            
        }

        imageView.image = img
        
    }
    
    // Example of drawing lines
    func drawLines() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            var first = true
            var length: CGFloat = 256
            
            for _ in 0 ..< 256 {
                ctx.cgContext.rotate(by: CGFloat.pi / 2)
                
                if first {
                    ctx.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                } else {
                    ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
                }
                
                length *= 0.99
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = img
    }
    
    // MARK: - Outlets
    @IBOutlet var imageView: UIImageView!
    
    // MARK: - Actions
    @IBAction func redrawTapped(_ sender: UIButton) {
        // Increment the drawing type
        currentDrawType += 1
        
        // Recycle draw type after 5 iterations
        if currentDrawType > 5 { currentDrawType = 0 }
        
        // Switch on draw type to see how to draw
        switch currentDrawType {
        case 0:
            drawRectangle()
        case 1:
            drawCircle()
        case 2:
            drawCheckerboard()
        case 3:
            drawRotatedSquares()
        case 4:
            drawLines()
        default:
            break
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        drawRectangle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

