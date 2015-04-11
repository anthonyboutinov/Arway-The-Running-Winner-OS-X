//
//  JSTileUtil.swift
//  BadTweet
//
//  Created by Anthony Boutinov on 2/12/15.
//  Copyright (c) 2015 Anthony Boutinov. All rights reserved.
//

import Foundation

extension JSTileMap {
    
    func tileRect(fromTileCoord tileCoord: CGPoint) -> CGRect {
        let levelHeightInPixels = self.mapSize.height * self.tileSize.height
        let origin = CGPoint(
            x: tileCoord.x * self.tileSize.width,
            y: levelHeightInPixels - ((tileCoord.y + 1) * self.tileSize.height)
        )
        return CGRectMake(origin.x, origin.y, self.tileSize.width, self.tileSize.height)
    }
    
    func tileGID(atTileCoord coord: CGPoint, forLayer layer: TMXLayer) -> Int {
        return Int(layer.layerInfo.tileGidAtCoord(coord))
    }
    
    func properties(forGID gid: Int) -> NSMutableDictionary? {
        return self.tileProperties[NSInteger(gid)] as? NSMutableDictionary
    }
}