//
//  Sound.swift
//  BadTweet
//
//  Created by Anthony Boutinov on 2/25/15.
//  Copyright (c) 2015 Anthony Boutinov. All rights reserved.
//

import Foundation
import AVFoundation

class Sound {
    
    static var music = false
    static var soundEffects = false
    
    static var backgroundMusic = AVAudioPlayer()
    
    static let coinSound = SKAction.playSoundFileNamed("coin.wav", waitForCompletion: false)
    static let jumpSound = SKAction.playSoundFileNamed("jump.wav", waitForCompletion: false)
    static let hurtSound = SKAction.playSoundFileNamed("hurt.wav", waitForCompletion: false)
    static let powerupSound = SKAction.playSoundFileNamed("powerup.wav", waitForCompletion: false)
    //static let menuSound = SKAction.playSoundFileNamed("menu.wav", waitForCompletion: false)
    
    class func initSharedInstance() {
        (soundEffects, music) = UserDefaults.SFXAndMusic()
        
        backgroundMusic = Sound.setupAudioPlayer(file: "6dfcd1ecc4db", ofType:"mp3")
        backgroundMusic.volume = 0.3
        if music {
            backgroundMusic.play()
        }
    }
    
    class func setupAudioPlayer(#file:NSString, ofType type:NSString) -> AVAudioPlayer  {
        let path = NSBundle.mainBundle().pathForResource(file as String, ofType:type as String)
        let audioPlayer: AVAudioPlayer? = AVAudioPlayer(contentsOfURL: NSURL.fileURLWithPath(path!), error: nil)
        return audioPlayer!
    }
    
    class func toggleSoundEffects() {
        soundEffects = !soundEffects
        UserDefaults.updateSFX(soundEffects)
    }
    
    class func toggleMusic() {
        music = !music
        UserDefaults.updateMusic(music)
        if music {
            backgroundMusic.play()
        } else {
            backgroundMusic.pause()
        }
    }
    
    class func playMenuSound() {
        if soundEffects {
            
        }
    }
    
}