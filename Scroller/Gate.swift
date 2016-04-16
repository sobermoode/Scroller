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
    let scaleFactor: CGFloat = 1.5
    
    override init()
    {
        super.init()
        
        self.gateTop.xScale = self.scaleFactor
        self.gateTop.yScale = self.scaleFactor
        self.gateTop.position = CGPointZero
        self.target.size = CGSize(width: self.gateTop.size.width, height: 95)
        self.target.position.x = self.gateTop.position.x
        self.target.position.y = self.gateTop.position.y - self.gateTop.size.height - 1
        self.gateBottom.xScale = self.scaleFactor
        self.gateBottom.yScale = self.scaleFactor
        self.gateBottom.position.x = self.gateTop.position.x
        self.gateBottom.position.y = self.target.position.y - self.target.size.height - 1
        
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
        
        let gateMove = SKAction.moveToX((-self.frame.width * 1.5), duration: 7)
        let gateRemoval = SKAction.removeFromParent()
        let gateSequence = SKAction.sequence([gateMove, gateRemoval])
        self.runAction(gateSequence)
        
        self.zPosition = 1
        
        self.addChild(self.gateTop)
        self.addChild(self.target)
        self.addChild(self.gateBottom)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
