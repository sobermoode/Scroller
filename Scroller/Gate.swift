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
    let spaceshipCategory: UInt32 = 0x1 << 0
    let enemyCategory: UInt32 = 0x1 << 1
    
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
        
        let totalWidth = self.gateTop.size.width
        let totalHeight = self.gateTop.size.height + self.target.size.height + self.gateBottom.size.height
        let gateSize = CGSize(width: totalWidth, height: totalHeight)
        self.physicsBody = SKPhysicsBody(rectangleOfSize: gateSize)
        self.physicsBody?.categoryBitMask = self.enemyCategory
        self.physicsBody?.contactTestBitMask = self.spaceshipCategory
        self.physicsBody?.collisionBitMask = 0
        
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
