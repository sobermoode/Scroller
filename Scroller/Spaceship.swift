//
//  Spaceship.swift
//  Scroller
//
//  Created by Aaron Justman on 4/20/16.
//  Copyright © 2016 AaronJ. All rights reserved.
//

import SpriteKit

class Spaceship : SKNode
{
    var sprite: SKSpriteNode!
    let imageName: String = "Spaceship"
    let xScaleFactor: CGFloat = 0.15
    let yScaleFactor: CGFloat = 0.225
    let rotation: CGFloat = -1.57
    let screenRect: CGRect = UIScreen.mainScreen().bounds
    var currentTouch: UITouch?
    
    init(scene: SKScene)
    {
        super.init()
        
        self.userInteractionEnabled = true
        self.name = "Spaceship"
        
        let spaceshipTexture = SKTexture(imageNamed: "Spaceship")
        sprite = SKSpriteNode(texture: spaceshipTexture)
        sprite.xScale = self.xScaleFactor
        sprite.yScale = self.yScaleFactor
        sprite.zRotation = self.rotation
        sprite.zPosition = 1
        
        let spaceshipSize = CGSize(width: spaceshipTexture.size().width * self.xScaleFactor, height: spaceshipTexture.size().height * self.yScaleFactor)
        sprite.physicsBody = SKPhysicsBody(texture: spaceshipTexture, size: spaceshipSize)
        sprite.physicsBody?.categoryBitMask = SKNode.ContactCategory.Spaceship
        sprite.physicsBody?.contactTestBitMask = SKNode.ContactCategory.Gate | SKNode.ContactCategory.Target
        sprite.physicsBody?.collisionBitMask = 0
        sprite.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(sprite)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        if let touch = touches.first
        {
            guard self.sprite.containsPoint(touch.locationInNode(self)) else
            {
                return
            }
            
            self.currentTouch = touch
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        if let currentTouch = self.currentTouch
        {
            let spaceshipPoint = currentTouch.locationInNode(self.sprite)
            let gameScenePoint = self.sprite.convertPoint(spaceshipPoint, toNode: self.scene!)
            self.position = gameScenePoint
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        if let scene = self.scene as? GameScene
        {
            self.currentTouch = nil
            scene.warpFactor = 1
            scene.backgroundImage.setSpeed(scene.warpFactor)
            scene.lastForce = 0
        }
    }
}
