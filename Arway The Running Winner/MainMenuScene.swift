//
//  MainMenu.swift
//  BadTweet
//
//  Created by Anthony Boutinov on 2/14/15.
//  Copyright (c) 2015 Anthony Boutinov. All rights reserved.
//

import Foundation

class MainMenuScene: SKScene {
    
    // MARK: Properties
    
    // MARK: UI Elements
    
    private let playButton = UIDesigner.button()
    private let settingsButton = UIDesigner.button()
    private let aboutButton = UIDesigner.button()
    
    // MARK: SKScene override methods
    
    override func didMoveToView(view: SKView) {
        let elements: [SKSpriteNode] = [playButton, settingsButton, aboutButton]
        let texts: [String] = ["Play", "Settings", "About"]
        UIDesigner.layoutButtonsWithText(scene: self, buttons: elements, texts: texts, zPosition: 2.0)
        UIDesigner.setBackground(self, isMainMenu: true)
        
        UIDesigner.addTitleAsImage("Logo", self, yOffset: 30.0)
    }
    
    override func mouseDown(theEvent: NSEvent) {
        let location = theEvent.locationInNode(self)
        for node in self.nodesAtPoint(location) as! [SKNode] {
            switch node {
            case playButton:
                goToPlayScreen()
            case settingsButton:
                goToSettings()
            case aboutButton:
                goToAbout()
            default:
                break
            }
        }
    }
    
    private func goToPlayScreen() {
//        if Sound_soundEffects {
//            self.runAction(menuSound)
//        }
        presentScene(PlayScene(), view!)
    }
    
    private func goToSettings() {
//        if Sound_soundEffects {
//            self.runAction(menuSound)
//        }
        presentScene(SettingsScene(), view!)
    }
    
    private func goToAbout() {
//        if Sound_soundEffects {
//            self.runAction(menuSound)
//        }
        presentScene(AboutScene(), view!)
    }
}