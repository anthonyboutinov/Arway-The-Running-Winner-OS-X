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
        let s1 = self.charactersIgnoringModifiers!.unicodeScalars
        return Int(s1[s1.startIndex].value)
    }
}