//
//  Player.swift
//  BadTweet
//
//  Created by Anthony Boutinov on 2/7/15.
//  Copyright (c) 2015 Anthony Boutinov. All rights reserved.
//

import Foundation

let defaultTimePerFrame = 0.35


class Player: DisplacementAble, Updatable, HoldsItsSprite {

    
    // MARK: Physical properties and constraints
    static private let minMovement = CGPoint(x: -220.0, y: -350.0)
    static private let maxMovement = CGPoint(x: 220.0, y: 350.0)
    static private let jumpForce = CGPoint(x: 0.0, y: 350.0)
    static private let jumpCutoff = CGFloat(150.0)
    static private let slipperyCoefficient = CGFloat(0.9)
    static private let movementMomentum = CGFloat(600.0)
    static private let powerUpMovementMomentumMultiplier = CGFloat(2.25)
    
    static private let powerUpTime: NSTimeInterval = 15.0
    
    static private let speedyTimePerFrame = 0.2
    
    private var timePerFrame = defaultTimePerFrame
    
//    static private let downForce = CGFloat(-2.8799999999999999)
    
    // MARK: - Variables
    // MARK: Sprite
    
    
    let sprite: SKSpriteNode
    
    class Hulk {
        static let walkRightTextures: [SKTexture] = [
            SKTexture(imageNamed: "HulkRW1"),
            SKTexture(imageNamed: "HulkRW2")
        ]
        static let walkLeftTextures: [SKTexture] = [
            SKTexture(imageNamed: "HulkLW1"),
            SKTexture(imageNamed: "HulkLW2")
        ]
        
        static let jumpRightTexture = SKTexture(imageNamed: "HulkRJ")
        static let jumpLeftTexture = SKTexture(imageNamed: "HulkLJ")
        
        static let fallRightTexture = SKTexture(imageNamed: "HulkRF")
        static let fallLeftTexture = SKTexture(imageNamed: "HulkLF")
        
        static let stillTexture = SKTexture(imageNamed: "HulkS")
    }
    
    class Arway {
        static let walkRightTextures: [SKTexture] = [
            SKTexture(imageNamed: "ArwayRW1"),
            SKTexture(imageNamed: "ArwayRW2")
        ]
        static let walkLeftTextures: [SKTexture] = [
            SKTexture(imageNamed: "ArwayLW1"),
            SKTexture(imageNamed: "ArwayLW2")
        ]
        
        static let jumpRightTexture = SKTexture(imageNamed: "ArwayRJ")
        static let jumpLeftTexture = SKTexture(imageNamed: "ArwayLJ")
        
        static let fallRightTexture = SKTexture(imageNamed: "ArwayRF")
        static let fallLeftTexture = SKTexture(imageNamed: "ArwayLF")
        
        static let stillTexture = SKTexture(imageNamed: "ArwayS")
    }
    
    private var currentFrameTime = 0.0
    private var currentTexture = 0
    
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
        
        sprite = SKSpriteNode(texture: Arway.stillTexture)
        sprite.zPosition = -21.0
        
        desiredPosition = position
        sprite.position = position
    }
    
    func update(# delta: CFTimeInterval) {

        let velocityStep = calculateVelocityStep(delta)
        desiredPosition += velocityStep
        updateFrameAmination(delta, displacement: velocityStep)
        
    }
    
    private func calculateVelocityStep(deltaTimeInterval: CFTimeInterval) -> CGPoint {
        
        let delta = CGFloat(deltaTimeInterval as Double)
        
        var forwardMove = CGPoint(x: Player.movementMomentum, y: 0.0)
        if backwardsMarch {
            forwardMove = CGPoint(x: -Player.movementMomentum, y: 0.0)
        }
        
        if !powerUpTimeLeft.isSignMinus {
            powerUpTimeLeft -= deltaTimeInterval
            forwardMove *= Player.powerUpMovementMomentumMultiplier
        }
        
        let forwardMoveStep = forwardMove * delta
        
        let gravityStep = Physics.gravity * delta
        velocity += gravityStep
        
        velocity.x *= Player.slipperyCoefficient
        
        // Jumping
        if mightAsWellJump && onGround {
            velocity += Player.jumpForce
            if Sound.soundEffects {
                sprite.runAction(Sound.jumpSound)
            }
        } else if !mightAsWellJump && velocity.y > Player.jumpCutoff {
            velocity = CGPoint(x: velocity.x, y: Player.jumpCutoff)
        }
        
        if forwardMarch || backwardsMarch {
            velocity += forwardMoveStep
        }
        
        velocity = CGPoint(
            x: Clamp(velocity.x, Player.minMovement.x, Player.maxMovement.x),
            y: Clamp(velocity.y, Player.minMovement.y, Player.maxMovement.y)
        )
        
        var velocityStep = velocity * delta
        if abs(velocityStep.x) > 0.0 && abs(velocityStep.x) < 0.01 {
            velocityStep.x = 0.0
        }
        return velocityStep
        
    }
    
    var waitingToBeRemoved: Bool = false
    
    private func updateFrameAmination(delta: CFTimeInterval, var displacement: CGPoint) {
        
        if powerUpTimeLeft <= 0.0 {
            timePerFrame = defaultTimePerFrame
        }
        
        var updateAlternatingAmination = false
        
        currentFrameTime += delta as Double
        if currentFrameTime > timePerFrame {
            currentFrameTime = 0.0
            updateAlternatingAmination = true
            currentTexture = currentTexture == 0 ? 1 : 0
        }
        
        let dxdy = calculateDisplacement(displacement, onGround)
        
        switch dxdy {
        case (.Right, .None):
            if powerUpTimeLeft > 0.0 {
                sprite.texture = Hulk.walkRightTextures[currentTexture]
            } else {
                sprite.texture = Arway.walkRightTextures[currentTexture]
            }
        case (.Left, .None):
            if powerUpTimeLeft > 0.0 {
                sprite.texture = Hulk.walkLeftTextures[currentTexture]
            } else {
                sprite.texture = Arway.walkLeftTextures[currentTexture]
            }
        case (.None, .None):
            if powerUpTimeLeft > 0.0 {
                sprite.texture = Hulk.stillTexture
            } else {
                sprite.texture = Arway.stillTexture
            }
        case (.None, .Up):
            if oldDisplacement.0 == .Left {
                if powerUpTimeLeft > 0.0 {
                    sprite.texture = Hulk.jumpLeftTexture
                } else {
                    sprite.texture = Arway.jumpLeftTexture
                }
            } else {
                if powerUpTimeLeft > 0.0 {
                    sprite.texture = Hulk.jumpRightTexture
                } else {
                    sprite.texture = Arway.jumpRightTexture
                }
            }
        case (.None, .Down):
            if oldDisplacement.0 == .Left {
                if powerUpTimeLeft > 0.0 {
                    sprite.texture = Hulk.fallLeftTexture
                } else {
                    sprite.texture = Arway.fallLeftTexture
                }
            } else {
                if powerUpTimeLeft > 0.0 {
                    sprite.texture = Hulk.fallRightTexture
                } else {
                    sprite.texture = Arway.fallRightTexture
                }
            }
        case (.Left, .Up):
            if powerUpTimeLeft > 0.0 {
                sprite.texture = Hulk.jumpLeftTexture
            } else {
                sprite.texture = Arway.jumpLeftTexture
            }
        case (.Right, .Up):
            if powerUpTimeLeft > 0.0 {
                sprite.texture = Hulk.jumpRightTexture
            } else {
                sprite.texture = Arway.jumpRightTexture
            }
        case (.Left, .Down):
            if powerUpTimeLeft > 0.0 {
                sprite.texture = Hulk.fallLeftTexture
            } else {
                sprite.texture = Arway.fallLeftTexture
            }
        case (.Right, .Down):
            if powerUpTimeLeft > 0.0 {
                sprite.texture = Hulk.fallRightTexture
            } else {
                sprite.texture = Arway.fallRightTexture
            }
        default:
            break
        }
        
        oldDisplacement = dxdy

    }
    
    var hasPowerUpOn: Bool {
        return powerUpTimeLeft > 0.0
    }
    
    func applyPowerUp() {
        if Sound.soundEffects {
            sprite.runAction(Sound.powerupSound)
        }
        powerUpTimeLeft = Player.powerUpTime
        timePerFrame = Player.speedyTimePerFrame
    }
    
}