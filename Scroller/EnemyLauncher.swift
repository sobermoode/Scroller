//
//  EnemyLauncher.swift
//  Scroller
//
//  Created by Aaron Justman on 4/13/16.
//  Copyright © 2016 AaronJ. All rights reserved.
//

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
        let yRange = SKRange(lowerLimit: CGRectGetMinY((self.scene?.view?.bounds)!) - newGate.frame.size.height, upperLimit: CGRectGetMaxY((self.scene?.view?.bounds)!) * 2.7)
        let yConstraint = SKConstraint.positionY(yRange)
        newGate.constraints = [yConstraint]
        newGate.position.x = CGRectGetMaxX((self.scene?.view?.bounds)!) * 1.5
        newGate.position.y = player.position.y
        scene.addChild(newGate)
        
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
