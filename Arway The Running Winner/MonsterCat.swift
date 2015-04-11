//
//  MonsterCat.swift
//  BadTweet
//
//  Created by Anthony Boutinov on 3/10/15.
//  Copyright (c) 2015 Anthony Boutinov. All rights reserved.
//

import Foundation

class MonsterCat: Enemy {
    
    static let defaultSpeed = CGFloat(40.0)
    static let defaultFireDelay: CFTimeInterval = 2.0
    static let defaultFireRepeatDelay: CFTimeInterval = 17.0
    
    var firstFirePerformed = false
    
    let speed:  CGFloat
    
    let sprite: SKSpriteNode
    
    var position: CGPoint {
        get {
            return sprite.position
        }
        set {
            sprite.position = newValue
        }
    }
    
    var waitingToBeRemoved: Bool = false
    
    var fireDelay: CFTimeInterval = MonsterCat.defaultFireDelay
    var fireRepeatDelay: CFTimeInterval = MonsterCat.defaultFireRepeatDelay
    
    required init(position: CGPoint) {
        self.sprite = SKSpriteNode(texture: SKTexture(imageNamed:"CatL"))
        self.speed = MonsterCat.defaultSpeed
        self.position = position
    }
    
    
    func fire() -> Updatable {
        let position = CGPoint(x: self.position.x - 40.0, y: self.position.y)
        return Tweet(position: position)
    }
    
    func isReadyToFire() -> Bool {
        if !firstFirePerformed && fireDelay <= 0.0 {
            firstFirePerformed = true
            return true
        }
        
        if firstFirePerformed {
            if fireRepeatDelay <= 0.0 {
                fireRepeatDelay = MonsterCat.defaultFireRepeatDelay
                return true
            }
        }
        return false
    }
    
    func update(delta deltaTimeInterval: CFTimeInterval) {
        let delta = CGFloat(deltaTimeInterval)
        sprite.position.x -= speed * delta
        if !firstFirePerformed {
            fireDelay -= deltaTimeInterval
        }
        fireRepeatDelay -= deltaTimeInterval
    }
    
}