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
    let maxInterval: NSTimeInterval = 5
    let scene: GameScene?
    let player: SKSpriteNode?
    // var currentEnemy: SKSpriteNode?
    var currentGate: Gate?
    // var lastLaunch = NSDate()
    let screenRect: CGRect = UIScreen.mainScreen().bounds
    
    init(scene: GameScene, player: SKSpriteNode)
    {
        self.scene = scene
        self.player = player
    }
    
    mutating func launchEnemy()
    {
        guard let scene = self.scene else
        {
            return
        }
        
        let newGate = Gate()
        let yRange = SKRange(lowerLimit: CGRectGetMinY(self.screenRect) + (newGate.calculateAccumulatedFrame().height), upperLimit: CGRectGetMaxY(self.screenRect) - (newGate.halfHeightOfGateCap()))
        let yConstraint = SKConstraint.positionY(yRange)
        newGate.constraints = [yConstraint]
        
        newGate.position.x = CGRectGetMaxX(self.screenRect) + newGate.calculateAccumulatedFrame().width
        let randoRange: UInt32 = UInt32(yRange.upperLimit) - UInt32(yRange.lowerLimit)
        let randoY: CGFloat = CGFloat(arc4random_uniform(randoRange) + UInt32(yRange.lowerLimit))
        newGate.position.y = randoY
        
        newGate.enemyLauncher = self
        self.currentGate = newGate
        
        scene.addChild(newGate)
        print("newGate.didHitGate: \(newGate.didHitGate)")
        
        // self.lastLaunch = NSDate()
    }
    
    func getCurrentGate() -> Gate?
    {
        return self.currentGate
    }
    
    mutating func removeCurrentGate()
    {
        self.currentGate = nil
    }
    
    /*
    func getCurrentEnemy() -> SKSpriteNode?
    {
        return self.currentEnemy
    }
    
    mutating func removeCurrentEnemy()
    {
        self.currentEnemy = nil
    }
    */
}
