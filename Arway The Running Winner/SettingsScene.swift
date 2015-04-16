//
//  SettingsScene.swift
//  BadTweet
//
//  Created by Anthony Boutinov on 2/16/15.
//  Copyright (c) 2015 Anthony Boutinov. All rights reserved.
//

import Foundation

final class SettingsScene: SKScene {
    
    // MARK: UI Elements
    
    private var backButton: SKSpriteNode!
    
    private let switchOn = SKTexture(imageNamed: "switch_on")
    private let switchOff = SKTexture(imageNamed: "switch_off")
    
    private var soundEffectsSwitch: SKSpriteNode!
    private var musicSwitch: SKSpriteNode!
    
    private let soundEffectsLabel = UIDesigner.label()
    private let musicLabel = UIDesigner.label()
    
    // MARK: SKScene override methods
    
    override func didMoveToView(view: SKView) {
        
        UIDesigner.setBackground(self)
        backButton = UIDesigner.addBackButton(self)
        let title = UIDesigner.addTitle("Settings", self)
        
        soundEffectsLabel.text = "Sound Effects"
        musicLabel.text = "Music"
        
//        let maxLabelLength = max(soundEffectsLabel.frame.width, musicLabel.frame.width)
        
        soundEffectsSwitch = Sound.soundEffects ? SKSpriteNode(texture: switchOn) : SKSpriteNode(texture: switchOff)
        musicSwitch = Sound.music ? SKSpriteNode(texture: switchOn) : SKSpriteNode(texture: switchOff)
        
        let yOffset =  -title.frame.height / 2
        var i = false
        for (label, switchSprite) in [(soundEffectsLabel, soundEffectsSwitch), (musicLabel, musicSwitch)] {
            
            var centerPoint = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) + yOffset)
            label.position = CGPoint(x: UIDesigner.margin * 3 + label.frame.width / 2, y: centerPoint.y)
            label.position.y += i ? -label.frame.height / 2 : label.frame.height / 2
            
            switchSprite.position = CGPoint(x: CGRectGetMaxY(self.frame), y: centerPoint.y)
            switchSprite.position.y += i ? -switchSprite.size.height / 2 : switchSprite.size.height / 2
            
            addChild(label)
            addChild(switchSprite)
            i = !i
        }
        
    }
    
    override func mouseDown(theEvent: NSEvent) {
        
        let location = theEvent.locationInNode(self)
        for node in self.nodesAtPoint(location) as! [SKNode] {
            switch node {
            case backButton:
                presentScene(MainMenuScene(), view!)
                
            case soundEffectsSwitch:
                fallthrough
            case soundEffectsLabel:
                Sound.toggleSoundEffects()
                soundEffectsSwitch.texture = Sound.soundEffects ? switchOn : switchOff
                
            case musicSwitch:
                fallthrough
            case musicLabel:
                Sound.toggleMusic()
                musicSwitch.texture = Sound.music ? switchOn : switchOff
                
            default:
                break
            }
        }
    }
    
    override func keyDown(theEvent: NSEvent) {
        let char = theEvent.character
        if char == NSEnterFunctionKey || char == NSBackspaceFunctionKey {
            presentScene(MainMenuScene(), view!)
        }
    }
    
}