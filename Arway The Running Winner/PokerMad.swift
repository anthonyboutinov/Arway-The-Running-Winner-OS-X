//
//  PokerMad.swift
//  BadTweet
//
//  Created by Anthony Boutinov on 2/14/15.
//  Copyright (c) 2015 Anthony Boutinov. All rights reserved.
//

import Foundation

class PokerMad: Enemy {
    
    let sprite: SKSpriteNode
    
    var position: CGPoint {
        get {
            return sprite.position
        }
        set {
            sprite.position = newValue
        }
    }
    
    required init(position: CGPoint) {
        self.sprite = SKSpriteNode()
        self.position = position
    }
    
    func fire() {
        
    }
    
    func update(delta deltaTimeInterval: CFTimeInterval) {
        
    }
    
}