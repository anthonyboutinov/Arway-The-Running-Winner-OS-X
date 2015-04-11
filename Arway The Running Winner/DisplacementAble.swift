//
//  DisplacementAble.swift
//  Arway The Running Winner
//
//  Created by Anthony Boutinov on 4/11/15.
//  Copyright (c) 2015 Anthony Boutinov. All rights reserved.
//

import Foundation

class DisplacementAble {
    
    enum Displacement {
        case Left, Right, Up, Down, None
    }
    
    var oldDisplacement: (Displacement, Displacement) = (.None, .None)
    
    func calculateDisplacement(var displacement: CGPoint, _ onGround: Bool) -> (Displacement, Displacement) {
        if abs(displacement.x) > 0.0 && abs(displacement.x) < 1.0 {
            displacement.x = 0.0
        }
        
        return (
            displacement.x > 0 ? Displacement.Right : displacement.x == 0 ? Displacement.None : Displacement.Left,
            displacement.y > 0 ? Displacement.Up : onGround ? Displacement.None : Displacement.Down
        )
    }
    
}