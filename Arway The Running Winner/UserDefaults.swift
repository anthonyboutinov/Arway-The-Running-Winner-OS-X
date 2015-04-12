//
//  UserDefaults.swift
//  BadTweet
//
//  Created by Anthony Boutinov on 2/22/15.
//  Copyright (c) 2015 Anthony Boutinov. All rights reserved.
//

import Foundation

class UserDefaults {
    
    // MARK: - Music & Sound Effects
    
    class func SFXAndMusic() -> (Bool, Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        return (!defaults.boolForKey("soundEffectsAreOff"), !defaults.boolForKey("musicIsOff"))
    }
    
    class func music() -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        return !defaults.boolForKey("musicIsOff")
    }
    
    class func updateSFX(value: Bool) {
        NSUserDefaults.standardUserDefaults().setBool(!value, forKey: "soundEffectsAreOff")
    }
    
    class func updateMusic(value: Bool) {
        NSUserDefaults.standardUserDefaults().setBool(!value, forKey: "musicIsOff")
    }
    
    class func toggleSFX() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(!defaults.boolForKey("soundEffectsAreOff"), forKey: "soundEffectsAreOff")
    }
    
    class func toggleMusic() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(!defaults.boolForKey("musicIsOff"), forKey: "musicIsOff")
    }
    
    // MARK: - World State
    
    class func save(worldState state: WorldState) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(state.world, forKey: "world")
        defaults.setInteger(state.level, forKey: "level")
        defaults.setInteger(state.numCoins, forKey: "numCoins")
        defaults.setInteger(state.numLives, forKey: "numLives")
    }
    
    class func loadWorldState() -> WorldStateWithUI? {
        let defaults = NSUserDefaults.standardUserDefaults()
        let numLives = defaults.integerForKey("numLives")
        if numLives == 0 {
            return nil
        } else {
            let world = defaults.integerForKey("world")
            let level = defaults.integerForKey("level")
            let numCoins = defaults.integerForKey("numCoins")
            return WorldStateWithUI(numCoins: numCoins, numLives: numLives, world: world, level: level)
        }
        
    }
    
    class func erase() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(0, forKey: "world")
        defaults.setInteger(0, forKey: "level")
        defaults.setInteger(0, forKey: "numCoins")
        defaults.setInteger(0, forKey: "numLives")
    }
    
}