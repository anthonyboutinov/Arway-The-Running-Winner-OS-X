//
//  Enemy.swift
//  BadTweet
//
//  Created by Anthony Boutinov on 2/14/15.
//  Copyright (c) 2015 Anthony Boutinov. All rights reserved.
//

import Foundation

protocol Enemy: Updatable, HoldsItsSprite {
    
    var fireDelay: CFTimeInterval {get}
    var fireRepeatDelay: CFTimeInterval {get}
    
    func fire() -> Updatable
    
    func isReadyToFire() -> Bool
}