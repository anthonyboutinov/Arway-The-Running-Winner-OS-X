//
//  HoldsItsSprite.swift
//  BadTweet
//
//  Created by Anthony Boutinov on 2/14/15.
//  Copyright (c) 2015 Anthony Boutinov. All rights reserved.
//

import Foundation
import SpriteKit

protocol HoldsItsSprite {
    var sprite: SKSpriteNode {get}
    var position: CGPoint {get set}
    
    init(position: CGPoint)
}