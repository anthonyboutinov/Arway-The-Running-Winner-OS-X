//
//  AppDelegate.swift
//  Arway The Running Winner
//
//  Created by Anthony Boutinov on 4/11/15.
//  Copyright (c) 2015 Anthony Boutinov. All rights reserved.
//


import Cocoa
import SpriteKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var skView: SKView!
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        // Init Sound
        Sound.initSharedInstance()
        
        // Get data from the database
        Tweets.getData()
        
        // Init Main Menu Scene
        let scene = MainMenuScene()
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        presentScene(scene, skView)
        
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }
    

}
