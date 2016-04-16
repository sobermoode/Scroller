//
//  EnemyLauncher.swift
//  Scroller
//
//  Created by Aaron Justman on 4/13/16.
//  Copyright © 2016 AaronJ. All rights reserved.
//

// import Foundation
import SpriteKit

struct EnemyLauncher
{
    let enemyImageName: String = "Enemy"
    let enemyScaleFactor: CGFloat = 1.5
    let maxInterval: NSTimeInterval = 3
    let scene: GameScene?
    let player: SKSpriteNode?
    var currentEnemy: SKSpriteNode?
    var lastLaunch = NSDate()
    let spaceshipCategory: UInt32 = 0x1 << 0
    let enemyCategory: UInt32 = 0x1 << 1
    
    // var delegate: EnemyRemoverDelegate?
    
    init(scene: GameScene, player: SKSpriteNode)
    {
        self.scene = scene
        self.player = player
    }
    
    mutating func launchEnemy()
    {
        guard let scene = self.scene,
            let player = self.player else
        {
            return
        }
        
        let newGate = Gate()
        newGate.position.x = CGRectGetMaxX((self.scene?.view?.bounds)!) * 1.5
        newGate.position.y = player.position.y
        scene.addChild(newGate)
        
        // self.currentEnemy = newEnemy
        self.lastLaunch = NSDate()
    }
    
    func getCurrentEnemy() -> SKSpriteNode?
    {
        return self.currentEnemy
    }
    
    mutating func removeCurrentEnemy()
    {
        self.currentEnemy = nil
    }
}

protocol EnemyRemoverDelegate
{
    func removeEnemyFromScene(scene: SKScene?)
}