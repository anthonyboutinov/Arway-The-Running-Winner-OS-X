//
//  Physics.swift
//  Arway The Running Winner
//
//  Created by Anthony Boutinov on 4/14/15.
//  Copyright (c) 2015 Anthony Boutinov. All rights reserved.
//

import Foundation

class Physics {
    
    static let gravity = CGPoint(x: 0.0, y: -450.0)
    
    static var controlRectSizes = CGFloat(45.0)
    static let indices: [Int] = [7, 1, 3, 5, 0, 2, 6, 8]
    
    // MARK: Enums
    
    // Tile Properties: preset and created during the game
    enum Properties: String {
        case isBouncy = "isBouncy" // The tile bounces when it's hit by the player's head
        case durability = "durability" // How many times the player has to hit this tile with his head in order for it to destroy. Each time tile's ducatility is decreased, it emits something (if it contains anything)
        case contains = "contains" // What the tile contains
        case hasBeenRemovedFromTheView = "r" // Marks that the tile has been removed from the view
        case willAutoRelease = "d" // Marks that the tile will be automatically removed when it finishes doing an action or an animation
    }
    
    enum GameOverState {
        case playerHasLost, playerHasWon
    }
    
    // Mark: Game Over Properties
    
    var gameOverState: GameOverState = .playerHasWon
    var gameIsOver: Bool {
        set {
            worldState.gameOver = newValue
            if gameIsOver {
                scene.showGameOverMenu()
            } else {
                scene.hideGameOverMenu()
            }
        }
        get {
            return worldState.gameOver
        }
    }
    
    
    
    
    private weak var scene: GameLevelScene!
    
    // MARK: WorldState
    
    var worldState: WorldStateWithUI
    
    // MARK: Physics World
    
    private var previousUpdateTime = NSTimeInterval()
    private let maxDelta = 0.04 // Initial was 0.02
    
    private var lastEnemyTime = NSTimeInterval()
    private var enemyOccurancePeriod = NSTimeInterval(15)
    
    // MARK: Game world entities
    var player: Player!
    var updatables: [Updatable] = [Updatable]()
    var enemies: [Enemy] = [Enemy]()
    var tweetsOnScreen: [Tweet] = [Tweet]()
    
    // MARK: Map of the level
    
    private var map: JSTileMap!
    private var walls: TMXLayer!
    private var hazards: TMXLayer!
    private var collidableItems: TMXLayer!
    private var noncollidableItems: TMXLayer!
    
    private var winLine = CGFloat(0)
    
    // MARK: Actions (Animations)
    
    private var bounce: SKAction!
    
    
    
    // MARK: Methods
    
    // MARK: Inits
    
    init(scene: GameLevelScene, worldState: WorldStateWithUI) {
        
        self.scene = scene
        self.worldState = worldState
        
        initAnimations()
        
        worldState.parentScene = scene
        
    }
    
    func initIntoScene() {
        initMap()
        initPlayer()
        worldState.addChildrenToScene()
    }
    
    private func initMap() {
        // Initialize map and add on screen
        map = JSTileMap(named: worldState.tmxFileName)
        scene.addChild(map)
        
        // Store layers in local properties for faster access
        walls = map.layerNamed("Walls")
        hazards = map.layerNamed("Hazards")
        collidableItems = map.layerNamed("CollidableItems")
        noncollidableItems = map.layerNamed("NoncollidableItems")
        
        // Set rightmost position in pixels after crossing which player is
        // declared a winner.
        if worldState.world == WorldState.totalNumberOfWorlds {
            winLine = (map.mapSize.height - 4) * map.tileSize.height
        } else {
            winLine = (map.mapSize.width - 5) * map.tileSize.width
        }
        
        // Set background color from map's property
        scene.backgroundColor = SKColor(hex: map.backgroundColor)
        
        let backgroundImage = SKSpriteNode(imageNamed: worldState.backgroundImageFileName)
        backgroundImage.position = CGPoint(x: CGRectGetMidX(scene.frame), y: CGRectGetMidY(scene.frame))
        backgroundImage.zPosition = -1000
        scene.addChild(backgroundImage)
        
    }
    
    private func initPlayer() {
        player = Player(position: CGPoint(x: map.tileSize.width * 5, y: map.tileSize.height * 4))
        map.addChild(player.sprite)
        updatables.append(player)
    }
    
    private func initAnimations() {
        
        // Bounce Action
        let bounceFactor = CGFloat(0.4)
        let dropHeight = CGFloat(10)
        let nDropHeight = CGFloat(-10)
        let dropActoin = SKAction.moveByX(0, y: nDropHeight, duration: 0.3)
        bounce = SKAction.sequence([
            SKAction.moveByX(0, y: dropHeight * bounceFactor, duration: 0.1),
            SKAction.moveByX(0, y: nDropHeight * bounceFactor, duration: 0.1)
            ])
        
    }
    func update(currentTime: CFTimeInterval) {
        
        if gameIsOver {
            return
        }
        
        var delta = currentTime - previousUpdateTime
        if delta > maxDelta {
            delta = maxDelta
        }
        
        // FIXME: Delete this line when ready to test on real device (LOW FPS)
        // Currently evetyrhing got adapted the way that this line is required. =/
        delta *= 2.0
        
        previousUpdateTime = currentTime
        
        // Update player and présent enemies
        var i = 0
        for updatable in updatables {
            if (updatable as! HoldsItsSprite).sprite.position.x < player.sprite.position.x - scene.frame.width {
                (updatable as! HoldsItsSprite).sprite.removeFromParent()
                var u = updatable
                u.waitingToBeRemoved = true
                updatables.removeAtIndex(i--)
            }
            updatable.update(delta: delta)
            i++
        }
        
        handleEnemyProduction(currentTime)
        
        interactWithTheWorld()
        checkForWin()
        setViewPointCenter(player.position)
        
    }
    
    private func handleEnemyProduction(currentTime: CFTimeInterval) {
        
        let delta = currentTime - lastEnemyTime
        if delta > enemyOccurancePeriod {
            lastEnemyTime = currentTime
            
            let random = 0.2 + CGFloat(Double(arc4random_uniform(6)) / 10.0)
            var position = CGPoint(
                x: player.sprite.position.x + scene.frame.width * 0.7,
                y: scene.frame.height * random
            )
            if worldState.world == WorldState.totalNumberOfWorlds {
                position.x += player.sprite.position.y
            }
            // TODO: WORLDSTATE COLORS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            let mainColor = worldState.world < 3 ? NSColor.blackColor() : NSColor.whiteColor()
            let cat = MonsterCat(position: position, mainColor: mainColor)
            map.addChild(cat.sprite)
            updatables.append(cat)
            enemies.append(cat)
        }
        
        var i = 0
        for enemy in enemies {
            if enemy.waitingToBeRemoved {
                enemies.removeAtIndex(i--)
            }
            if enemy.isReadyToFire() {
                let tweet = enemy.fire() as! Tweet
                map.addChild(tweet.sprite)
                updatables.append(tweet)
                tweetsOnScreen.append(tweet)
            }
            i++
        }
        
    }
    
    // MARK: Collisions
    
    private func interactWithTheWorld() {
        
        player.onGround = false
        
        for i in 0..<Physics.indices.count {
            
            // It is assumed that all layers have the same offset and size properties.
            // So here 'Walls' layer is used, since player's position is the same
            // with respect to all of the layers.
            let playerCoord: CGPoint = walls.coordForPoint(player.desiredPosition)
            // If the player starts to fall through the bottom of the map
            // then it's game over.
            if playerCoord.y >= map.mapSize.height - 1 {
                
                gameOverState = .playerHasLost
                gameIsOver = true
                
                if Sound.soundEffects {
                    scene.runAction(Sound.hurtSound)
                }
                
                return
            }
            let playerRect: CGRect = player.collisionBoundingBox
            
            let tileIndex = Physics.indices[i]
            let tileColumn = tileIndex % 3
            let tileRow = tileIndex / 3
            let tileCoord = CGPoint(
                x: playerCoord.x + CGFloat(tileColumn - 1),
                y: playerCoord.y + CGFloat(tileRow - 1))
            
            checkAndResolveCollisions(layer: walls, tileIndex, tileCoord, playerRect)
            
            if checkIfCollidedWithAHazard(tileCoord, playerRect) {
                return
            }
            
            checkAndResolveCollisions(layer: collidableItems, tileIndex, tileCoord, playerRect)
            
            // TODO: Здесь можно везде упростить, убрав playerRect, так как теперь он не вычисляется каждый раз при обращении, а временно хранит вычисленное значение между изменениями
            handleNonCollidableItems(tileCoord, playerRect)
            
        }
        
        checkForCollisionsWithEnemies()
        
        // Apply resolved position to the player's sprite
        player.position = player.desiredPosition
    }
    
    private func checkAndResolveCollisions(#layer: TMXLayer, _ tileIndex: Int, _ tileCoord: CGPoint, _ playerRect: CGRect) {
        
        let gid: Int = map.tileGID(atTileCoord: tileCoord, forLayer: layer)
        // If gid is not black space
        if gid != 0 {
            let tileRect = map.tileRect(fromTileCoord: tileCoord)
            
            // Collision resolution
            if CGRectIntersectsRect(playerRect, tileRect) {
                let intersection = CGRectIntersection(playerRect, tileRect)
                if (tileIndex == 7) {
                    
                    // Tile is directly below the player
                    player.desiredPosition.y += intersection.size.height
                    player.velocity.y = 0.0
                    player.onGround = true
                    
                } else if (tileIndex == 1) {
                    
                    // Tile is directly above the player
                    player.desiredPosition.y -= intersection.size.height
                    
                    if layer == collidableItems {
                        handleItemsCollisions(tileCoord, gid)
                    } else {
                        bounceTileIfItHasBouncingProperty(layer.tileAtCoord(tileCoord), gid)
                    }
                    
                } else if (tileIndex == 3) {
                    
                    // Tile is left of the player
                    player.desiredPosition.x += intersection.size.width
                    
                } else if (tileIndex == 5) {
                    
                    // Tile is right of the player
                    player.desiredPosition.x -= intersection.size.width
                    
                } else if (intersection.size.width > intersection.size.height) {
                    
                    // Tile is diagonal, but resolving collision vertically
                    player.velocity.y = 0.0
                    var intersectionHeight = CGFloat(0)
                    if (tileIndex > 4) {
                        intersectionHeight = intersection.size.height
                        player.onGround = true
                    } else {
                        intersectionHeight = -intersection.size.height
                    }
                    player.desiredPosition.y += intersection.size.height
                    
                } else {
                    
                    // Tile is diagonal, but resolving horizontally
                    var intersectionWidth = CGFloat(0)
                    if (tileIndex == 6 || tileIndex == 0) {
                        intersectionWidth = intersection.size.width
                    } else {
                        intersectionWidth = -intersection.size.width
                    }
                    player.desiredPosition.x += intersectionWidth
                }
            }
        }
        
    }
    
    private func checkIfCollidedWithAHazard(tileCoord: CGPoint, _ playerRect: CGRect) -> Bool {
        let gid = map.tileGID(atTileCoord: tileCoord, forLayer: hazards)
        if gid != 0 {
            let tileRect = map.tileRect(fromTileCoord: tileCoord)
            if CGRectIntersectsRect(playerRect, tileRect) {
                
                gameOverState = .playerHasLost
                gameIsOver = true
                
                if Sound.soundEffects {
                    scene.runAction(Sound.hurtSound)
                }
                
                return true
            }
        }
        return false
    }
    
    private func checkForCollisionsWithEnemies() -> Bool {
        for enemy in enemies {
            if checkForCollisionsWithEnemy(enemy) {
                return true
            }
        }
        var i = 0
        for tweet in tweetsOnScreen {
            if tweet.waitingToBeRemoved {
                tweetsOnScreen.removeAtIndex(i--)
            }
            if checkForCollisionsWithEnemy(tweet) {
                return true
            }
            i++
        }
        return false
    }
    
    private func checkForCollisionsWithEnemy(spriteHolder: HoldsItsSprite) -> Bool {
        let rect = spriteHolder.sprite.frame
        let playerRect = player.collisionBoundingBox
        if CGRectIntersectsRect(playerRect, rect) {
            if player.hasPowerUpOn {
                
                spriteHolder.sprite.removeFromParent()
                var s = (spriteHolder as! Updatable)
                s.waitingToBeRemoved = true
                
                if Sound.soundEffects {
                    scene.runAction(Sound.hissSound)
                }
                
                
            } else {
                gameOverState = .playerHasLost
                gameIsOver = true
                
                if Sound.soundEffects {
                    scene.runAction(Sound.hissSound)
                }
            }
            return true
        }
        return false
    }
    
    private func handleNonCollidableItems(tileCoord: CGPoint, _ playerRect: CGRect) {
        let gid = map.tileGID(atTileCoord: tileCoord, forLayer: noncollidableItems)
        if gid != 0 {
            if let tile = noncollidableItems.tileAtCoord(tileCoord) {
                
                // If tile has been removed from the view,
                if let _ = tile.userData?[Properties.hasBeenRemovedFromTheView.rawValue] {
                    // Then skip it.
                    return
                }
                
                let tileRect = map.tileRect(fromTileCoord: tileCoord)
                if CGRectIntersectsRect(playerRect, tileRect) {
                    if let properties = map.properties(forGID: gid) {
                        checkContainsPropertyOfATile(properties)
                    }
                    
                    // Add flag to the tile
                    tile.userData = [Properties.hasBeenRemovedFromTheView.rawValue:true]
                    tile.removeFromParent()
                    
                }
            }
        }
    }
    
    private func handleItemsCollisions(tileCoord: CGPoint, _ gid: Int) {
        let layer = collidableItems
        
        // Tile is directly above the player
        let tile = layer.tileAtCoord(tileCoord)
        
        if tile == nil {
            return
        }
        
        if let properties = tile!.userData {
            // Optimized and personalized properties
            
            // WARNING: When editing this, remember to write an adoptation of it
            // for the non-optimized properties below
            
            // Return if the tile has 'willAutoRelease' property
            if let _ = properties[Properties.willAutoRelease.rawValue] {
                return
            }
            
            if var durability = properties[Properties.durability.rawValue] as? Int {
                handleDurability(durability, properties, layer, tileCoord, tile)
            }
            if checkContainsPropertyOfATile(properties) {
                return
            }
            
        } else if let properties: NSMutableDictionary = map.tileProperties[NSInteger(gid)] as? NSMutableDictionary {
            // Non-optimized and non-personalized properties
            
            // WARNING: When editing this, remember to write an adoptation of it
            // for the optimized properties above
            
            // Save a copy to tile's userData and edit it
            tile!.userData = properties
            
            if var durability = (properties[Properties.durability.rawValue] as? String)?.toInt() {
                handleDurability(durability, properties, layer, tileCoord, tile)
            }
            if checkContainsPropertyOfATile(properties) {
                return
            }
        }
    }
    
    private func handleDurability(var durability: Int, _ properties: NSMutableDictionary, _ layer: TMXLayer, _ tileCoord: CGPoint, _ tile: SKSpriteNode) {
        durability--
        player.velocity.y = 0.0
        if durability < 1 {
            // Remove tile after optional bounce animation
            if let _ = properties[Properties.isBouncy.rawValue] {
                tile.runAction(bounce, completion: {layer.removeTileAtCoord(tileCoord)})
                properties[Properties.willAutoRelease.rawValue] = true
            } else {
                layer.removeTileAtCoord(tileCoord)
            }
            // Don't bother updating durability value if it's going to be removed anyway
        } else {
            // Here: update the value
            properties[Properties.durability.rawValue] = durability
            // Bounce
            if let _ = properties[Properties.isBouncy.rawValue] {
                tile.runAction(bounce)
            }
        }
    }
    
    private func checkContainsPropertyOfATile(properties: NSMutableDictionary) -> Bool {
        if let contains = properties["contains"] as? String {
            switch contains {
            case "coin":
                worldState.numCoins++
                if Sound.soundEffects {
                    scene.runAction(Sound.coinSound)
                }
            case "powerUp":
                player.applyPowerUp()
            default:
                break
            }
            return true
        }
        return false
    }
    
    private func setViewPointCenter(position: CGPoint) {
        var x = max(position.x, scene.size.width / 2)
        var y = max(position.y, scene.size.height / 2)
        x = min(x, (map.mapSize.width * map.tileSize.width) - scene.size.width / 2)
        y = min(y, (map.mapSize.height * map.tileSize.height) - scene.size.height / 2)
        let actualPosition = CGPoint(x: x, y: y)
        let centerOfView = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        let viewPoint = centerOfView - actualPosition
        map.position = viewPoint
    }
    
    private func bounceTileIfItHasBouncingProperty(tile: SKSpriteNode, _ gid: Int) {
        if let _ = map.properties(forGID: gid)?[Properties.isBouncy.rawValue] {
            tile.runAction(bounce)
        }
    }
    
    private func checkForWin() {
        if (worldState.world == WorldState.totalNumberOfWorlds && player.position.y > winLine) || player.position.x > winLine {
            gameOverState = .playerHasWon
            gameIsOver = true
        }
    }

    
    
}