//
//  JSTileUtil.swift
//  BadTweet
//
//  Created by Anthony Boutinov on 2/12/15.
//  Copyright (c) 2015 Anthony Boutinov. All rights reserved.
//

import Foundation

extension JSTileMap {
    
    func tileRect(fromTileCoord tileCoord: CGPoint, onLayer layer: TMXLayer? = nil) -> CGRect {
        let levelHeightInPixels = self.mapSize.height * self.tileSize.height
        let origin = CGPoint(
            x: tileCoord.x * self.tileSize.width,
            y: levelHeightInPixels - ((tileCoord.y + 1) * self.tileSize.height)
        )
        
        if let rect = customCollisionBoundingBox(tileCoord, layer, origin) {
            return rect
        }
        
        return CGRect(x: origin.x, y: origin.y, width: self.tileSize.width, height: self.tileSize.height)
    }
    
    private func customCollisionBoundingBox(tileCoord: CGPoint, _ layer: TMXLayer?, _ origin: CGPoint) -> CGRect? {
        if let layer = layer {
            let tile = layer.tileAtCoord(tileCoord)
            if let userData = tile.userData {
                // if userData has 'upperSlab' for key 'customCollisionBoundingBoxType'
                if let type = userData[Physics.Properties.customCollisionBoundingBoxType.rawValue] as? String {
                    if type == Physics.Properties.upperSlab.rawValue {
                        return CGRect(x: origin.x, y: origin.y + self.tileSize.height / 2.0, width: self.tileSize.width, height: self.tileSize.height / 2.0)
                    } else if type == Physics.Properties.lowerSlab.rawValue {
                        return CGRect(x: origin.x, y: origin.y + 2.0, width: self.tileSize.width, height: self.tileSize.height / 2.0 + 2.0)
                    }
                }
            }
        }
        return nil
    }
    
    func tileGID(atTileCoord coord: CGPoint, forLayer layer: TMXLayer) -> Int {
        return Int(layer.layerInfo.tileGidAtCoord(coord))
    }
    
    func properties(forGID gid: Int) -> NSMutableDictionary? {
        return self.tileProperties[NSInteger(gid)] as? NSMutableDictionary
    }
}