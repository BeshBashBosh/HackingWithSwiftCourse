//
//  GradientView.swift
//  PsychicTester
//
//  Created by Ben Hall on 01/05/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit

@IBDesignable class GradientView: UIView {
    // Set top and bottom colors of Gradient and make them inspectable in IB
    @IBInspectable var topColor: UIColor = .white
    @IBInspectable var bottomColor: UIColor = .black
    
    // This tells iOS that when it requests what kind of layer it is we want a CAGradientLayer
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    // This tells iOS that when the view lays out its subviews is should apply the colors to the gradient
    override func layoutSubviews() {
        (layer as! CAGradientLayer).colors = [topColor.cgColor, bottomColor.cgColor]
    }
}
