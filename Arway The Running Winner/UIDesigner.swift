//
//  DesignElements.swift
//  BadTweet
//
//  Created by Anthony Boutinov on 2/16/15.
//  Copyright (c) 2015 Anthony Boutinov. All rights reserved.
//

import Foundation

final class UIDesigner {
    
//    static let primaryColor = NSColor(hex: 0x2d57a1)
    static let primaryColor = NSColor(hexAsString: "#2d57a1")
    
    static let gameFont = "Helvetica-Nueue-Thin"
    
    static let blueButtonTexture = SKTexture(imageNamed: "blue_button")
    static let backButtonTexture = SKTexture(imageNamed: "back_button")
    
    static let buttonBottomMargin = CGFloat(5)
    
    static let margin = CGFloat(18.0)
    static let padding = UIDesigner.margin / 3
    
    class func button() -> SKSpriteNode {
        return SKSpriteNode(texture: UIDesigner.blueButtonTexture)
    }
    
    class func label(font: String = gameFont) -> SKLabelNode {
        return SKLabelNode(fontNamed: font)
    }
    
    class func setBackground(scene: SKScene, isMainMenu: Bool = false) {
//        scene.backgroundColor = primaryColor
        let name = isMainMenu ? "BackgroundMainMenu" : "Background"
        let bg = SKSpriteNode(imageNamed: name)
        bg.zPosition = -1000
        bg.position = CGPoint(x: CGRectGetMidX(scene.frame), y: CGRectGetMidY(scene.frame))
        scene.addChild(bg)
    }
    
    class func insertTextIntoButton(button: SKSpriteNode, _ text: String) -> SKLabelNode {
        let label = SKLabelNode(fontNamed: UIDesigner.gameFont)
        label.text = text
        label.position.y -= label.frame.height / 2 - buttonBottomMargin
        button.addChild(label)
        return label
    }
    
    class func layoutButtonsWithText(#scene: SKScene, buttons: [SKSpriteNode], texts: [String], zPosition: CGFloat? = nil, hidden: Bool? = nil) -> [SKLabelNode] {
        assert(buttons.count == texts.count, "Number of buttons is not equal to number of texts")
        
        var labels: [SKLabelNode] = [SKLabelNode]()
        
        let midX = CGRectGetMidX(scene.frame)
        let midY = CGRectGetMidY(scene.frame)
        
        let elementHeight = blueButtonTexture.size().height
        for _i in 0..<buttons.count {
            let button = buttons[_i]
            let i = CGFloat(_i)
            
            button.position = CGPoint(x: midX, y: midY + (CGFloat(Int(buttons.count / 2)) - i) * elementHeight * 1.2)
            
            labels.append(UIDesigner.insertTextIntoButton(button, texts[_i]))
            
            if let zPosition = zPosition {
                button.zPosition = zPosition
            }
            
            if let hidden = hidden {
                button.hidden = hidden
            }
            
            scene.addChild(button)
        }
        return labels
    }
    
    class func addBackButton(scene: SKScene) -> SKSpriteNode {
        let button = SKSpriteNode(texture: backButtonTexture)
        button.position = CGPoint(x: CGRectGetMinX(scene.frame) + margin + button.size.width / 2, y: CGRectGetMaxY(scene.frame) - margin - button.size.height / 2)
        
        scene.addChild(button)
        return button
    }
    
    class func layoutTextTable(texts: [String], _ scene: SKScene, positionOffsetY: CGFloat, margin customMargin: CGFloat = margin, var fontSize: CGFloat? = nil) {
        let minX = CGRectGetMinX(scene.frame) + customMargin
        let midX = CGRectGetMidX(scene.frame)
        let midY = CGRectGetMidY(scene.frame)
        
        // Next line: Relative spacing between lines
        let paddingInPercent = CGFloat(0.05)
        let lowerCoeff = 1 - paddingInPercent
        let upperCoeff = 1 + paddingInPercent
        
        let fitIntoRectOfSize = CGSize(width: minX - CGRectGetMaxX(scene.frame) - customMargin, height: CGRectGetMaxY(scene.frame) - positionOffsetY - customMargin * 2)
        if fontSize == nil {
            fontSize = fitIntoRectOfSize.height / CGFloat(texts.count) * lowerCoeff
        }
        
        let sampleLabel = SKLabelNode(fontNamed: gameFont)
        sampleLabel.fontSize = fontSize!
        sampleLabel.text = "QW,$|`qpd"
        let elementHeight = sampleLabel.frame.height
        
        let coeff = CGFloat(Int(texts.count / 4))
        
        var column = CGFloat(0)
        var titleColumn = true // The first column is called Title Column
        for text in texts {
            
            if text.isEmpty {
                titleColumn = !titleColumn
                if titleColumn {
                    column++
                }
                continue
            }
            
            let label = SKLabelNode(fontNamed: gameFont)
            label.fontSize = fontSize!
            label.text = text
            
            if titleColumn {
                label.position.x = minX + label.frame.width / 2
            } else {
                label.position.x = midX + customMargin / 2 + label.frame.width / 2
            }
            
            label.position.y = midY + (coeff - column) * elementHeight * upperCoeff + positionOffsetY
            
            scene.addChild(label)
            
            titleColumn = !titleColumn
            if titleColumn {
                column++
            }
        }
    }
    
    class func addTitle(text: String, _ scene: SKScene, font: String = gameFont, fontSize: Int = 42, yOffset: CGFloat = CGFloat(0.0)) -> SKLabelNode {
        let title = SKLabelNode(fontNamed: font)
        title.fontSize = CGFloat(fontSize)
        title.text = text
        title.position = CGPoint(x: CGRectGetMidX(scene.frame), y: CGRectGetMaxY(scene.frame) - margin - title.frame.height + yOffset)
        scene.addChild(title)
        return title
    }
    
    class func addTitleAsImage(imageNamed: String, _ scene: SKScene, yOffset: CGFloat = CGFloat(0.0)) -> SKSpriteNode {
        let title = SKSpriteNode(imageNamed: imageNamed)
        title.position = CGPoint(x: CGRectGetMidX(scene.frame), y: CGRectGetMaxY(scene.frame) - margin - title.frame.height + yOffset)
        scene.addChild(title)
        return title
    }
    
}