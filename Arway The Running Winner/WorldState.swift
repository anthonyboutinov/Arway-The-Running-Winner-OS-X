//
//  WorldState.swift
//  BadTweet
//
//  Created by Anthony Boutinov on 2/8/15.
//  Copyright (c) 2015 Anthony Boutinov. All rights reserved.
//

import Foundation

class WorldState: Printable {
    
    static let defaultNumberOfLives = 3
    static let coinsToLifeThreshold = 200
    static let levelsPerWorld = 2
    static let totalNumberOfWorlds = 4
    
    // MARK: - Variables
    
    var description: String {
        return "WorldState(World \(world) Level \(level), \(numCoins) coins, \(numLives) lives)"
    }
    
    var numCoins: Int {
        didSet {
            if numCoins != 0 && numCoins % WorldState.coinsToLifeThreshold == 0 {
                numLives++
            }
        }
    }
    var numLives: Int {
        didSet {
            // Reset game if no lives left
            if numLives < 1 {
                world = 1
                level = 1
                numLives = WorldState.defaultNumberOfLives
                numCoins = 0
            }
        }
    }
    
    var world: Int
    
    // When player finishes the last level of a world, player transitions
    // to the next world and level numeration starts over.
    var level: Int {
        didSet {
            if level > WorldState.levelsPerWorld {
                level = 1
                world++
            } else if level < 1 && world > 1 {
                level = WorldState.levelsPerWorld
                world--
            }
        }
    }

var tmxFileName: String {
    return "World\(world)Level\(level).tmx"
    }
    
    var backgroundImageFileName: String {
        return "World\(world)Level\(level)"
    }
    
    var gameOver = false
        
    // MARK: - Methods
    
    init(numCoins: Int = 0, numLives: Int = defaultNumberOfLives, world: Int = 1, level: Int = 1) {
        self.numCoins = numCoins
        self.numLives = numLives
        self.world = world
        self.level = level
    }
    
    func advanceToTheNextLevel() {
        level++
        
        if isTheEndOfTheGame() {
            UserDefaults.erase()
        } else {
            UserDefaults.save(worldState: self)
        }
    }
    
    func isTheEndOfTheGame() -> Bool {
        return world == WorldState.totalNumberOfWorlds && level == WorldState.levelsPerWorld // last world last level is nonexistent, so the game ends here
    }
    
}