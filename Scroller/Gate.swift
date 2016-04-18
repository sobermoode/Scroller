//
//  Gate.swift
//  Scroller
//
//  Created by Aaron Justman on 4/15/16.
//  Copyright © 2016 AaronJ. All rights reserved.
//

import SpriteKit

class Gate: SKNode
{
    let gateTop = SKSpriteNode(imageNamed: "Enemy")
    let target = SKSpriteNode(color: UIColor.clearColor(), size: CGSizeZero)
    let gateBottom = SKSpriteNode(imageNamed: "Enemy")
    let scaleFactor: CGFloat = 0.75
    var didHitGate: Bool = false
    let screenRect: CGRect = UIScreen.mainScreen().bounds
    var enemyLauncher: EnemyLauncher!
    
    override init()
    {
        super.init()
        
        self.gateTop.xScale = self.scaleFactor
        self.gateTop.yScale = self.scaleFactor
        self.gateTop.position = CGPointZero
        self.target.size = CGSize(width: self.gateTop.size.width, height: 85)
        self.target.position.x = self.gateTop.position.x
        self.target.position.y = self.gateTop.position.y - (self.gateTop.size.height * 1.75)
        self.gateBottom.xScale = self.scaleFactor
        self.gateBottom.yScale = self.scaleFactor
        self.gateBottom.position.x = self.gateTop.position.x
        self.gateBottom.position.y = self.target.position.y - (self.target.size.height / 1.5)
        
        self.gateTop.physicsBody = SKPhysicsBody(circleOfRadius: self.gateTop.size.width / 2)
        self.gateTop.physicsBody?.categoryBitMask = SKNode.ContactCategory.Gate
        self.gateTop.physicsBody?.contactTestBitMask = SKNode.ContactCategory.Spaceship
        self.gateTop.physicsBody?.collisionBitMask = SKNode.ContactCategory.None
        self.gateTop.physicsBody?.usesPreciseCollisionDetection = true
        self.target.physicsBody = SKPhysicsBody(rectangleOfSize: self.target.size)
        self.target.physicsBody?.categoryBitMask = SKNode.ContactCategory.Target
        self.target.physicsBody?.contactTestBitMask = SKNode.ContactCategory.Spaceship
        self.target.physicsBody?.collisionBitMask = SKNode.ContactCategory.None
        self.target.physicsBody?.usesPreciseCollisionDetection = true
        self.gateBottom.physicsBody = SKPhysicsBody(circleOfRadius: self.gateBottom.size.width / 2)
        self.gateBottom.physicsBody?.categoryBitMask = SKNode.ContactCategory.Gate
        self.gateBottom.physicsBody?.contactTestBitMask = SKNode.ContactCategory.Spaceship
        self.gateBottom.physicsBody?.collisionBitMask = SKNode.ContactCategory.None
        self.gateBottom.physicsBody?.usesPreciseCollisionDetection = true
        
        let gateMove = SKAction.moveToX(CGRectGetMinX(self.screenRect) - (self.calculateAccumulatedFrame().width * 2), duration: 7)
        let checkForMissedGate = SKAction.runBlock()
        {
            if !self.didHitGate
            {
                let gameScene = self.scene as! GameScene
                let score = gameScene.scoreLabel.currentScore
                
                let transition = SKTransition.flipVerticalWithDuration(0.5)
                let scene = GameOverScene(size: (self.scene?.size)!, score: score)
                self.scene?.view?.presentScene(scene, transition: transition)
            }
        }
        let gateRemoval = SKAction.removeFromParent()
//        let gateRemoval = SKAction.runBlock()
//        {
//            self.removeFromParent()
//        }
        let nextGate = SKAction.runBlock()
        {
            self.enemyLauncher.launchEnemy()
        }
        let gateSequence = SKAction.sequence([gateMove, checkForMissedGate, nextGate, gateRemoval])
        self.runAction(gateSequence)
        
        self.zPosition = 1
        
        self.addChild(self.gateTop)
        self.addChild(self.target)
        self.addChild(self.gateBottom)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func halfHeightOfGateCap() -> CGFloat
    {
        return self.gateTop.size.height / 2
    }
}
