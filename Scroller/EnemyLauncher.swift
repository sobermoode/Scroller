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
        
        let newEnemy = SKSpriteNode(imageNamed: self.enemyImageName)
        newEnemy.xScale = self.enemyScaleFactor
        newEnemy.yScale = self.enemyScaleFactor
        newEnemy.zPosition = 1
        newEnemy.position.x = CGRectGetMaxX((self.scene?.view?.bounds)!) * 1.5
        newEnemy.position.y = player.position.y
        
        let enemyMove = SKAction.moveToX(-newEnemy.size.width, duration: 7)
        newEnemy.runAction(enemyMove)
        
        scene.addChild(newEnemy)
        
        self.currentEnemy = newEnemy
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