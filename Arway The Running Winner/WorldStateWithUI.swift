//
//  WorldStateUI.swift
//  BadTweet
//
//  Created by Anthony Boutinov on 2/9/15.
//  Copyright (c) 2015 Anthony Boutinov. All rights reserved.
//

import Foundation

final class WorldStateWithUI: WorldState {
    
    // Parent scene
    weak var parentScene: GameLevelScene?
    
    let uiCoinsImage = SKSpriteNode(imageNamed: "hud_coins")
    let uiCoinsText = UIDesigner.uiOverlayLabel()
    var uiLivesImages: [SKSpriteNode] = [SKSpriteNode]()
    let uiLivesLabel = UIDesigner.uiOverlayLabel()
    let uiWorldLevelLabel = UIDesigner.uiOverlayLabel(fontSize: 18)
    
    private let uiLifeImageTexture = SKTexture(imageNamed: "hud_heartFull")
    
    override var numCoins: Int {
        didSet {
            uiCoinsText.text = String(numCoins)
        }
    }
    override var numLives: Int {
        didSet {
            if oldValue != 1 && numLives != WorldState.defaultNumberOfLives && numLives > oldValue {
                if Sound.soundEffects {
                    parentScene!.runAction(Sound.extraLifeSound)
                }
            }
            
            if oldValue == WorldState.defaultNumberOfLives && numLives > oldValue {
                
                // Transition from 'x sprites' to 'single sprite times number'
                for i in 1..<WorldState.defaultNumberOfLives {
                    uiLivesImages[i].hidden = true
                }
                uiLivesLabel.text = " x \(numLives)"
                uiLivesLabel.hidden = false
                
            } else if oldValue == WorldState.defaultNumberOfLives + 1 && numLives == WorldState.defaultNumberOfLives {
                
                // Transition from 'single sprite times number' to 'x sprites'
                uiLivesLabel.hidden = true
                for i in 1..<WorldState.defaultNumberOfLives {
                    uiLivesImages[i].hidden = false
                }
                
            } else if numLives <= WorldState.defaultNumberOfLives {
                
                // Case 'x sprites'
                for i in 0..<WorldState.defaultNumberOfLives {
                    if i < numLives {
                        uiLivesImages[i].hidden = false
                    } else {
                        uiLivesImages[i].hidden = true
                    }
                }
                
            } else {
                
                // Case 'single sprite times number'
                uiLivesLabel.text = " x \(numLives)"
            }
        }
    }
    
    override var gameOver: Bool {
        didSet {
            if gameOver == true {
                removeChildrenFromOldScene()
            }
        }
    }
    
    override init(numCoins: Int = 0, numLives: Int = defaultNumberOfLives, world: Int = 1, level: Int = 1) {
        
        super.init(numCoins: numCoins, numLives: numLives, world: world, level: level)
        
        for i in 0..<WorldState.defaultNumberOfLives {
            let life = SKSpriteNode(texture: uiLifeImageTexture)
            life.zPosition = 1
            life.anchorPoint = CGPoint(x: 0.0, y: 1.0)
            uiLivesImages.append(life)
        }
        
        uiLivesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        uiCoinsText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        uiWorldLevelLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        
        // Trigger 'didSet's
        self.numLives = numLives
        self.numCoins = numCoins
        self.world = world
        self.level = level
        
        
    }
    
    private func updateWorldLevelLabel() {
        uiWorldLevelLabel.text = "World \(world) Level \(level)"
    }
    
    func removeChildrenFromOldScene() {
        let nodes = [uiCoinsText, uiCoinsImage, uiWorldLevelLabel, uiLivesLabel] + (uiLivesImages as [SKNode])
        uiWorldLevelLabel.parent!.removeChildrenInArray(nodes)
    }
    
    func addChildrenToScene() {
        
        // Unwrap Optional
        assert(self.parentScene != nil, "Propery parentScene is not set")
        let scene = self.parentScene!
        
        // Force update worldLevelLabel, because there are no listeners set
        // for worldLevel's variables
        updateWorldLevelLabel()
        
        // Nodes are all the UI elements to be added to the scene
        let nodes = [uiCoinsText, uiCoinsImage, uiWorldLevelLabel, uiLivesLabel] + (uiLivesImages as [SKNode])
        
        // If nodes already have parent node,
        if let oldParent = uiLivesLabel.parent {
            // Then remove them from their parent node.
            oldParent.removeChildrenInArray(uiLivesImages)
            oldParent.removeChildrenInArray([uiLivesLabel])
            // If that is not true, then they must have been initialized already
            // and have their properties set, so 'else' closure shouldn't be
            // executed.
        } else {
            // Position life image nodes
            for _i in 0..<WorldState.defaultNumberOfLives {
                let i = CGFloat(_i)
                let life = uiLivesImages[_i]
                life.position = CGPoint(x: UIDesigner.margin + life.size.width * i + UIDesigner.padding, y: CGRectGetMaxY(scene.frame) - UIDesigner.margin)
            }
            
            // Position other nodes
            uiWorldLevelLabel.position = CGPoint(x: CGRectGetMidX(scene.frame), y: CGRectGetMaxY(scene.frame) - UIDesigner.margin)
            uiWorldLevelLabel.position.y -= uiWorldLevelLabel.frame.height
            uiCoinsImage.anchorPoint = CGPoint(x: 1.0, y: 1.0)
            uiCoinsImage.position = CGPoint(x: CGRectGetMaxX(scene.frame) - UIDesigner.margin, y: CGRectGetMaxY(scene.frame) - UIDesigner.margin)
            // Next line: shift coin's position more to the left from the pause
            // button so they're not intersecting each other
            uiCoinsImage.position.x -= uiCoinsImage.size.width * 2 + UIDesigner.margin
            uiCoinsText.position = CGPoint(x: uiCoinsImage.position.x - uiCoinsImage.size.width - UIDesigner.padding, y: uiCoinsImage.position.y)
            uiCoinsText.position.y -= uiCoinsText.frame.height
            uiLivesLabel.position = CGPoint(x: uiLivesImages[0].position.x + uiLivesImages[0].size.width, y: uiCoinsText.position.y)
        }
        
        // Add all nodes to the scene
        for node in nodes {
            scene.addChild(node)
        }
    }
    
}