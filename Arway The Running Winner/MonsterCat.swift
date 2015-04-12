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
    static let defaultFireRepeatDelay: CFTimeInterval = 400.0 // no repeat this way
    
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
    
    var mainColor: NSColor!
    
    var waitingToBeRemoved: Bool = false
    
    var fireDelay: CFTimeInterval = MonsterCat.defaultFireDelay
    var fireRepeatDelay: CFTimeInterval = MonsterCat.defaultFireRepeatDelay
    
    convenience required init(position: CGPoint) {
        self.init(position: position, mainColor: NSColor.blackColor())
    }
    
    init(position: CGPoint, mainColor: NSColor) {
        self.mainColor = mainColor
        
        self.sprite = SKSpriteNode(texture: SKTexture(imageNamed:"CatL"))
        self.speed = MonsterCat.defaultSpeed
        self.position = position
    }
    
    
    func fire() -> Updatable {
        let position = CGPoint(x: self.position.x - 40.0, y: self.position.y)
        return Tweet(position: position, mainColor: mainColor)
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