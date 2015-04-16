//
//  MainMenu.swift
//  BadTweet
//
//  Created by Anthony Boutinov on 2/14/15.
//  Copyright (c) 2015 Anthony Boutinov. All rights reserved.
//

import Foundation

final class MainMenuScene: SKScene {
    
    // MARK: Properties
    
    // MARK: UI Elements
    
    private let playButton = UIDesigner.button()
    private let settingsButton = UIDesigner.button()
    private let aboutButton = UIDesigner.button()
    
    private let errorMessageLabel: [SKLabelNode] = [UIDesigner.label(), UIDesigner.label()]
    
    private static let errorMessageNoTweets: [String] = [
        "Couldn't get data from the database. Please, press 'PLAY' to try again.",
        "Check if you are connected to the internet."
    ]
    
    private var errorMessageIsOnScreen = false
    
    // MARK: SKScene override methods
    
    override func didMoveToView(view: SKView) {
        let elements: [SKSpriteNode] = [playButton, settingsButton, aboutButton]
        let texts: [String] = ["Play", "Settings", "About"]
        UIDesigner.layoutButtonsWithText(scene: self, buttons: elements, texts: texts, zPosition: 2.0)
        UIDesigner.setBackground(self, isMainMenu: true)
        
        UIDesigner.addTitleAsImage("Logo", self, yOffset: 30.0)
        
        if !Tweets.didLoad {
            showErrorMessage()
        }
        
    }
    
    func showErrorMessage(text: [String] = MainMenuScene.errorMessageNoTweets) {
        if !errorMessageIsOnScreen {
            errorMessageIsOnScreen = true
            
            let dimmerHeight = CGFloat(90.0)
            let dimmer = SKShapeNode(rect: CGRect(x: 0, y: 0, width: self.size.width, height: dimmerHeight))
            dimmer.fillColor = SKColor(white: 0.1, alpha: 0.6)
            dimmer.lineWidth = 0
            addChild(dimmer)

            errorMessageLabel[0].fontSize = 18.0
            errorMessageLabel[1].fontSize = 18.0
            errorMessageLabel[0].text = text[0]
            errorMessageLabel[1].text = text[1]

            errorMessageLabel[0].position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMinY(self.frame) + 50.0)
            errorMessageLabel[1].position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMinY(self.frame) + 30.0)
            addChild(errorMessageLabel[0])
            addChild(errorMessageLabel[1])
        }
    }
    
    override func mouseDown(theEvent: NSEvent) {
        let location = theEvent.locationInNode(self)
        for node in self.nodesAtPoint(location) as! [SKNode] {
            switch node {
            case playButton:
                play()
            case settingsButton:
                goToSettings()
            case aboutButton:
                goToAbout()
            default:
                break
            }
        }
    }
    
    override func keyDown(theEvent: NSEvent) {
        switch theEvent.character {
        case NSEnterFunctionKey:
            play()
        default:
            break
        }
    }
    
    private func tryToLoadTweetsAgainAndGoToPlayScreenOnSuccess() {
        Tweets.getData()
        if Tweets.didLoad {
            goToPlayScreen()
        } else {
            showErrorMessage()
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
    
    private func play() {
        if Tweets.didLoad {
            goToPlayScreen()
        } else {
            tryToLoadTweetsAgainAndGoToPlayScreenOnSuccess()
        }
    }
}