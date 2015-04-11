//
//  CGExtinsionFormulas.swift
//  BadTweet
//
//  Created by Anthony Boutinov on 2/8/15.
//  Copyright (c) 2015 Anthony Boutinov. All rights reserved.
//

import Foundation

func presentScene(scene: SKScene, view: SKView) {
    scene.anchorPoint = CGPoint(x: 0.0, y: 0.0)
    scene.scaleMode = .ResizeFill
    scene.size = view.bounds.size
    view.presentScene(scene)
}

// Extends CGPoint manipulations

// Multiplies CGPoint's values by CGFloat
func CGPointMultiplyScalar(var point: CGPoint, float: CGFloat) -> CGPoint {
    point.x *= float
    point.y *= float
    return point
}

// Adds two CGPoints
func CGPointAdd(var a: CGPoint, b: CGPoint) -> CGPoint {
    a.x += b.x
    a.y += b.y
    return a
}

// Subtracts two CGPoints
func CGPointSubtract(var a: CGPoint, b: CGPoint) -> CGPoint {
    a.x -= b.x
    a.y -= b.y
    return a
}

// Ensures that a scalar value stays with the range [min..max], inclusive
func Clamp(value: CGFloat, min: CGFloat, max: CGFloat) -> CGFloat {
    return value < min ? min : value > max ? max : value;
}

extension NSColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
//    convenience init(hex:Int) {
//        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
//    }
    
    // UIColor convenience initializer that
    // takes Objective-C's unsigned as given by the NSParser from NSString
    convenience init(hex hexAsUnsigned:UInt32) {
        let hex = Int(hexAsUnsigned)
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
    
}