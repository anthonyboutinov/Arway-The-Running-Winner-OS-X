//
//  GameScene.swift
//  BadTweet
//
//  Created by Anthony Boutinov on 2/6/15.
//  Copyright (c) 2015 Anthony Boutinov. All rights reserved.
//

import SpriteKit

class GameLevelScene: SKScene {
    
    // MARK: Variables
    
    var physics: Physics!
    
    // MARK: UI elements
    
    private var upButton: SKShapeNode!
    private var leftButton: SKShapeNode!
    private var rightButton: SKShapeNode!
    
    private let pauseButton = SKSpriteNode(imageNamed: "pause")
    
    private let gameOverLabel = SKLabelNode(fontNamed: UIDesigner.gameFont)
    private let replayButton = UIDesigner.button()
    private let mainMenuButtonNextToReplayButton = UIDesigner.button()
    private var replayButtonLabel: SKLabelNode!
    
    // MARK: Pause Scene
    
    private var dimmer: SKShapeNode!
    private let unpauseButton = UIDesigner.button()
    private let mainMenuButton = UIDesigner.button()
    private let settingsButton = UIDesigner.button()
    private var pauseMenuElements: [SKNode] = [SKNode]()
    
    private var gameIsPaused: Bool = false {
        didSet {
            hidePauseMenu(!self.gameIsPaused)
        }
    }
    
    // MARK: - Methods
    
    convenience init(worldState: WorldStateWithUI) {
        self.init()
        physics = Physics(scene: self, worldState: worldState)
    }
    
    // MARK: didMoveToView
    
    override func didMoveToView(view: SKView) {
        
        initUI()
        initPauseMenu()
        initGameOverStuff()
        
        physics.initIntoScene()
        
    }
    
    // MARK: Keyboard input
    
    override func keyDown(theEvent: NSEvent) {
        
        switch theEvent.character {
        case NSSpacebarKey:
            physics.player.mightAsWellJump = true
            return
        case NSUpArrowFunctionKey:
            physics.player.mightAsWellJump = true
            return
        case NSLeftArrowFunctionKey:
            physics.player.backwardsMarch = true
            return
        case NSRightArrowFunctionKey:
            physics.player.forwardMarch = true
            return
        case NSEqualsOrPlusKey:
            physics.gameOverState = .playerHasWon
            physics.gameIsOver = true
            if physics.worldState.isTheEndOfTheGame() {
            } else {
                replay()
            }
        case NSEnterFunctionKey:
            if gameIsPaused {
                gameIsPaused = false
            } else if physics.gameIsOver {
                if physics.worldState.isTheEndOfTheGame() {
                    goToTheMainMenuScene()
                } else {
                    replay()
                }
            } else {
                gameIsPaused = true
            }
        case NSBackspaceFunctionKey:
            if gameIsPaused || physics.gameIsOver {
                goToTheMainMenuScene()
            }
        default:
//            println(theEvent.character)
            break
        }
        super.keyDown(theEvent)
        
    }
    
    override func keyUp(theEvent: NSEvent) {
        
        switch theEvent.character {
        case NSUpArrowFunctionKey:
            physics.player.mightAsWellJump = false
            return
        case NSLeftArrowFunctionKey:
            physics.player.backwardsMarch = false
            return
        case NSRightArrowFunctionKey:
            physics.player.forwardMarch = false
            return
        default:
            break
        }
        super.keyDown(theEvent)
        
    }
    
    // MARK: Mouse input
    
    override func mouseDown(theEvent: NSEvent) {
        let location = theEvent.locationInNode(self)
        for node in self.nodesAtPoint(location) as! [SKNode] {
            if gameIsPaused {
                switch node {
                case unpauseButton:
                    gameIsPaused = false
                case mainMenuButton:
                    goToTheMainMenuScene()
                case settingsButton:
                    // TODO: Setting button action
                    break
                default: break
                }
            } else if physics.gameIsOver {
                switch node {
                case replayButton:
                    replay()
                case mainMenuButtonNextToReplayButton:
                    goToTheMainMenuScene()
                default: break
                }
            } else if node == pauseButton {
                gameIsPaused = true
            }
        }
    }
    
    // MARK: Initializers
    
    private func initUI() {
        
        // Define some constants
        let edge = CGFloat(18)
        let uiZPosition = CGFloat(50)
        
        // Handle Pause Button
        pauseButton.zPosition = uiZPosition
        pauseButton.anchorPoint = CGPointMake(1, 1)
        pauseButton.position = CGPointMake(CGRectGetMaxX(self.frame) - edge, CGRectGetMaxY(self.frame) - edge)
        addChild(pauseButton)
        
        // Compute Sizes
        let controlWidth = self.frame.width * 0.35
        let halfConfrolWidth = controlWidth * 0.5
        let controlHeight = self.frame.height * 0.5
        let halfControlHeight = controlHeight * 0.5
        
        // Init variables
        upButton = SKShapeNode(rectOfSize: CGSizeMake(controlWidth, self.frame.height - pauseButton.size.height - edge * 2))
        leftButton = SKShapeNode(rectOfSize: CGSizeMake(controlWidth, controlHeight))
        rightButton = SKShapeNode(rectOfSize: CGSizeMake(controlWidth, controlHeight))
        
        // Position them
        upButton!.position = CGPointMake(self.frame.width - halfConfrolWidth, CGRectGetMidY(self.frame) - edge * 2.5)
        leftButton!.position = CGPointMake(halfConfrolWidth, CGRectGetMaxY(self.frame) - controlHeight + halfControlHeight)
        rightButton!.position = CGPointMake(halfConfrolWidth, CGRectGetMinY(self.frame) + halfControlHeight)
        
        // Set some other properties and add them on screen
        for shapeNode in [upButton, rightButton, leftButton] {
            shapeNode.zPosition = uiZPosition
            shapeNode.alpha = 0.0
            addChild(shapeNode)
        }
    }
    
    
    
    private func initPauseMenu() {
        dimmer = SKShapeNode(rect: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        dimmer.fillColor = SKColor(white: 0.1, alpha: 0.7)
        dimmer.zPosition = 50.0
        dimmer.hidden = true
        addChild(dimmer)
        
        UIDesigner.layoutButtonsWithText(
            scene: self,
            buttons: [unpauseButton, settingsButton, mainMenuButton],
            texts: ["Continue", "Settings", "Main Menu"],
            zPosition: 60.0,
            hidden: true
        )
        
        pauseMenuElements = [dimmer, unpauseButton, mainMenuButton, settingsButton]
    }
    
    private func initGameOverStuff() {
        gameOverLabel.fontSize = 40
        gameOverLabel.position = CGPoint(x: self.size.width / 2.0, y: self.size.height / 1.5)
        gameOverLabel.hidden = true
        addChild(gameOverLabel)
        
        let labels = UIDesigner.layoutButtonsWithText(
            scene: self,
            buttons: [replayButton, mainMenuButtonNextToReplayButton],
            texts: ["Replay", "Main Menu"],
            zPosition: 60.0,
            hidden: true
        )
        replayButtonLabel = labels[0]
    }
    
    // MARK: Update
    
    override func update(currentTime: CFTimeInterval) {
        // Do not perform updates if game is over
        if gameIsPaused {
            return
        }
        
        physics.update(currentTime)
    }
    
    // MARK: Game over
    
    func showGameOverMenu() {
        switch physics.gameOverState {
            
        case .playerHasWon:
            gameOverLabel.text = "You Win!"
            replayButtonLabel.text = "Continue"
            physics.worldState.advanceToTheNextLevel()
            
        case .playerHasLost:

            // Next line: this means "if numLives == 1 before subtracting one."
            // This construction is required because numLives never reaches 0.
            // Instead, worldState is reset at that point.
            if physics.worldState.numLives-- == 1 {
                gameOverLabel.text = "Game Over"
            } else {
                gameOverLabel.text = "You've lost a life"
            }
            replayButtonLabel.text = "Replay"
        }
        
        // FIXME: gameOverLabel does not show up
        for node in [gameOverLabel, replayButton, mainMenuButtonNextToReplayButton] {
            if !(physics.worldState.isTheEndOfTheGame() && node == replayButton) {
                node.hidden = false
            }
        }
    }
    
    func hideGameOverMenu() {
        for node in [gameOverLabel, replayButton, mainMenuButtonNextToReplayButton] {
            node.hidden = true
        }
    }
        
    private func replay() {
        physics.worldState.gameOver = false
        
        // Configure scene
        let scene = GameLevelScene(worldState: physics.worldState)
//        scene.physics.worldState = physics.worldState
//        scene.physics.worldState.parentScene = scene
        
        presentScene(scene, view!)
    }
    
    // MARK: - Pause Menu
    
    private func hidePauseMenu(hidden: Bool) {
        paused = !hidden
        for element in pauseMenuElements {
            element.hidden = hidden
        }
        pauseButton.hidden = !hidden
    }
    
    private func goToTheMainMenuScene() {
        presentScene(MainMenuScene(), view!)
    }
    
}
