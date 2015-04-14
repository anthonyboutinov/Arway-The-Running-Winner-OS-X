//
//  NSUtils.swift
//  Arway The Running Winner
//
//  Created by Anthony Boutinov on 4/11/15.
//  Copyright (c) 2015 Anthony Boutinov. All rights reserved.
//

import Foundation

extension NSEvent {
    var character: Int {
        let s = self.charactersIgnoringModifiers!.unicodeScalars
        return Int(s[s.startIndex].value)
    }
}

let NSSpacebarKey = 32
let NSEqualsOrPlusKey = 61
let NSEnterFunctionKey = 13
let NSBackspaceFunctionKey = 127