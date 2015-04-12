//
//  Tweet.swift
//  BadTweet
//
//  Created by Anthony Boutinov on 3/10/15.
//  Copyright (c) 2015 Anthony Boutinov. All rights reserved.
//

import Foundation

typealias TweetStruct = (author:String, text:String)

class Tweet: Updatable, HoldsItsSprite {
    
    static let defaultSpeed = CGFloat(52.0)
    
    let sprite: SKSpriteNode
    
    let speed:  CGFloat
    
    var position: CGPoint {
        get {
            return sprite.position
        }
        set {
            sprite.position = newValue
        }
    }
    
    var waitingToBeRemoved: Bool = false
    
    convenience required init(position: CGPoint) {
//        let empty = TweetStruct("@unknownauthor", "[Quite short censored text here]")
        self.init(Tweets.getNext(), position: position, speed: Tweet.defaultSpeed)
    }
    
    required init(_ content:TweetStruct, position: CGPoint, speed: CGFloat) {
        self.sprite = Tweet.spriteForTweetContent(content)
        self.speed = speed
        self.position = position
    }
    
    func update(delta deltaTimeInterval: CFTimeInterval) {
        let delta = CGFloat(deltaTimeInterval)
        sprite.position.x -= speed * delta
    }
    
    class func spriteForTweetContent(tweet: TweetStruct) -> SKSpriteNode {
        
        let textLabel = SKLabelNode(fontNamed: UIDesigner.gameFont)
        textLabel.fontSize = 15.0
        textLabel.fontColor = NSColor.blackColor()
        textLabel.text = tweet.text
        
        let authorLabel = SKLabelNode(fontNamed: UIDesigner.gameFont)
        authorLabel.fontSize = 13.0
        authorLabel.fontColor = NSColor.grayColor()
        authorLabel.text = tweet.author
        authorLabel.position.y -= 17.0
        authorLabel.position.x += textLabel.frame.width / 2.0 - authorLabel.frame.width / 2.0
        
        let sprite = SKSpriteNode()
        sprite.addChild(authorLabel)
        sprite.addChild(textLabel)
        sprite.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        
//        let sprite = SKSpriteNode(color: UIColor.whiteColor(), size: CGSizeMake(width: tweet.text / 140.0 * 30.0, height: 20.0))
        
        
        return sprite
    }
    
}