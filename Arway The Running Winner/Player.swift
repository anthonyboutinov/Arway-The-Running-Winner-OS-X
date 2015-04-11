//
//  Player.swift
//  BadTweet
//
//  Created by Anthony Boutinov on 2/7/15.
//  Copyright (c) 2015 Anthony Boutinov. All rights reserved.
//

import Foundation

class Player: Updatable, HoldsItsSprite {
    
    // MARK: Physical properties and constraints
    static private let minMovement = CGPoint(x: -120.0, y: -350.0)
    static private let maxMovement = CGPoint(x: 120.0, y: 350.0)
    static private let jumpForce = CGPoint(x: 0.0, y: 350.0)
    static private let jumpCutoff = CGFloat(150.0)
    static private let slipperyCoefficient = CGFloat(0.6)
    
    private let powerUpTime: NSTimeInterval = 30.0
    
    // MARK: - Variables
    // MARK: Sprite
    
    let sprite: SKSpriteNode
    private let walkTextures: [SKTexture] = [
        SKTexture(imageNamed: "HeroRa1"),
        SKTexture(imageNamed: "HeroRa2")
    ]
    private let jumpTexture = SKTexture(imageNamed: "alienGreen_jump")
    private let hurtTexture = SKTexture(imageNamed: "alienGreen_hurt")
//    private var spriteWalkAnimationAction: SKAction?
    
    // MARK: Physical properties
    
    var velocity = CGPoint(x: 0.0, y: 0.0)
    
    private var collisionBoundingBoxChanged = true
    private var _collisionBoundingBox: CGRect!
    var collisionBoundingBox: CGRect {
        if collisionBoundingBoxChanged {
            let boundingBox = CGRectInset(sprite.frame, 2, 0)
            let diff = CGPoint(x: desiredPosition.x - sprite.position.x, y: desiredPosition.y - sprite.position.y)
            _collisionBoundingBox = CGRectOffset(boundingBox, diff.x, diff.y)
            collisionBoundingBoxChanged = false
        }
        return _collisionBoundingBox
    }
    
    var position: CGPoint {
        get {
            return sprite.position
        }
        set {
            sprite.position = newValue
            collisionBoundingBoxChanged = true
        }
    }
    
    var forwardMarch: Bool = false {
        didSet {
            if forwardMarch && backwardsMarch {
                backwardsMarch = false
            }
        }
    }
    var backwardsMarch: Bool = false {
        didSet {
            if backwardsMarch && forwardMarch {
                forwardMarch = false
            }
        }
    }
    
    var mightAsWellJump = false
    var onGround = false
    
    var desiredPosition: CGPoint {
        didSet {
            collisionBoundingBoxChanged = true
        }
    }
    
    var powerUpTimeLeft: NSTimeInterval = 0.0

    // MARK: - Methods
    
    required init(position: CGPoint) {
        
        sprite = SKSpriteNode(texture: walkTextures[0])
        sprite.zPosition = -21.0
        
        let animateWalkAction = SKAction.animateWithTextures(walkTextures, timePerFrame: 0.40);
        let spriteWalkAnimationAction = SKAction.repeatActionForever(animateWalkAction);
        sprite.runAction(spriteWalkAnimationAction)
        
        desiredPosition = position
        sprite.position = position
    }
    
    func update(delta deltaTimeInterval: CFTimeInterval) {
        // Make delta to be CGFloat
        let delta = CGFloat(deltaTimeInterval as Double)
        
        if powerUpTimeLeft > 0.0 {
            powerUpTimeLeft -= deltaTimeInterval
        }
        
        var forwardMove = CGPoint(x: 800.0, y: 0.0)
        if backwardsMarch {
            forwardMove = CGPoint(x: -800.0, y: 0.0)
        }
        if powerUpTimeLeft > 0.0 && forwardMarch {
            forwardMove = CGPoint(x: 1200.0, y: 0.0)
        }
        let forwardMoveStep = CGPointMultiplyScalar(forwardMove, delta)
        
        let gravityStep = CGPointMultiplyScalar(GameLevelScene.gravity, delta)
        velocity = CGPointAdd(velocity, gravityStep)
        
        velocity.x *= Player.slipperyCoefficient
        
        // Jumping
        if mightAsWellJump && onGround {
            velocity = CGPointAdd(velocity, Player.jumpForce)
            if Sound.soundEffects {
                sprite.runAction(Sound.jumpSound)
            }
        } else if !mightAsWellJump && velocity.y > Player.jumpCutoff {
            velocity = CGPoint(x: velocity.x, y: Player.jumpCutoff)
        }
        
        if forwardMarch || backwardsMarch {
            velocity = CGPointAdd(velocity, forwardMoveStep)
        }

        velocity = CGPoint(x: Clamp(velocity.x, Player.minMovement.x, Player.maxMovement.x), y: Clamp(velocity.y, Player.minMovement.y, Player.maxMovement.y))
        
        let velocityStep = CGPointMultiplyScalar(velocity, delta)
        desiredPosition = CGPointAdd(desiredPosition, velocityStep)
    }
    
    func applyPowerUp() {
        sprite.runAction(Sound.powerupSound)
        powerUpTimeLeft = powerUpTime
    }
    
}