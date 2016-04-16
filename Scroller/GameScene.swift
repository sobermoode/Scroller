//
//  GameScene.swift
//  Scroller
//
//  Created by Aaron Justman on 4/12/16.
//  Copyright (c) 2016 AaronJ. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var backgroundImage: SKSpriteNode!
    var backgroundImage2: SKSpriteNode!
    var spaceship: SKSpriteNode!
    var warpFactor: CGFloat = 1
    var currentTouch: UITouch?
    var sustainedSpeed: Int = 0
    var enemyLauncher: EnemyLauncher!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        let spaceshipCategory: UInt32 = 0x1 << 0
        let enemyCategory: UInt32 = 0x1 << 1
        
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        self.physicsWorld.contactDelegate = self
        
        self.backgroundImage = SKSpriteNode(imageNamed: "Background")
        // let xFactor: CGFloat = ((self.view?.bounds.width)! / self.backgroundImage.size.width)
        // let yFactor: CGFloat = ((self.view?.bounds.height)! / self.backgroundImage.size.height)
        self.backgroundImage.xScale =  3.2
        self.backgroundImage.yScale =  2.7
        self.backgroundImage.anchorPoint = CGPoint(x: 0, y: 0.0)
        self.backgroundImage.zPosition = 0
        self.backgroundImage.position = CGPoint(x: CGRectGetMinX((self.view?.bounds)!), y: CGRectGetMinY((self.view?.bounds)!))
        
        self.backgroundImage2 = SKSpriteNode(imageNamed: "Background")
        self.backgroundImage2.xScale = 3.2
        self.backgroundImage2.yScale = 2.7
        self.backgroundImage2.anchorPoint = CGPoint(x: 0, y: 0.0)
        self.backgroundImage2.zPosition = 0
        self.backgroundImage2.position = CGPoint(x: self.backgroundImage.size.width, y: self.backgroundImage.position.y)
        
        let backgroundScroll = SKAction.moveByX(-self.backgroundImage.size.width * self.warpFactor, y: 0, duration: 7)
        let continuousScroll = SKAction.repeatActionForever(backgroundScroll)
        
        self.spaceship = SKSpriteNode(imageNamed: "Spaceship")
        self.spaceship.xScale = 0.20
        self.spaceship.yScale = 0.35
        self.spaceship.zRotation = -1.57
        self.spaceship.zPosition = 1
        let xRange = SKRange(lowerLimit: CGRectGetMinX((self.view?.bounds)!), upperLimit: CGRectGetMaxX((self.view?.bounds)!) * 3.2)
        let yRange = SKRange(lowerLimit: CGRectGetMinY((self.view?.bounds)!), upperLimit: CGRectGetMaxY((self.view?.bounds)!) * 2.7)
        let xConstraint = SKConstraint.positionX(xRange)
        let yConstraint = SKConstraint.positionY(yRange)
        self.spaceship.constraints = [xConstraint, yConstraint]
        self.spaceship.physicsBody = SKPhysicsBody(rectangleOfSize: self.spaceship.size)
        // self.spaceship.physicsBody?.dynamic = false
        self.spaceship.physicsBody?.categoryBitMask = spaceshipCategory
        self.spaceship.physicsBody?.contactTestBitMask = enemyCategory
        self.spaceship.physicsBody?.collisionBitMask = 0
        self.spaceship.position = CGPoint(x: CGRectGetMinX((self.view?.bounds)!) + 115, y: CGRectGetMidY((self.view?.bounds)!) + (self.spaceship.size.height * 2))
        
        enemyLauncher = EnemyLauncher(scene: self, player: self.spaceship)
        enemyLauncher.launchEnemy()
        // enemyLauncher.delegate = self
        
        self.addChild(backgroundImage)
        self.addChild(backgroundImage2)
        self.addChild(spaceship)
        
        self.backgroundImage.runAction(continuousScroll)
        self.backgroundImage2.runAction(continuousScroll)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        if let touch = touches.first
        {
            guard self.spaceship.containsPoint(touch.locationInNode(self)) else
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
            self.spaceship.position = currentTouch.locationInNode(self)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.currentTouch = nil
        self.warpFactor = 1
        self.backgroundImage.speed = self.warpFactor
        self.backgroundImage2.speed = self.warpFactor
        self.sustainedSpeed = 0
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        if let currentTouch = self.currentTouch
        {
            if currentTouch.force == currentTouch.maximumPossibleForce
            {
                self.sustainedSpeed += 1
                
                if self.sustainedSpeed > 125
                {
                    self.warpFactor = currentTouch.force * 3
                }
            }
            else if currentTouch.force <= 1
            {
                self.warpFactor = 1
            }
            else if currentTouch.force > 1
            {
                self.warpFactor = currentTouch.force * 2
            }
            
            self.backgroundImage.speed = self.warpFactor
            self.backgroundImage2.speed = self.warpFactor
            
            if let currentEnemy = self.enemyLauncher.getCurrentEnemy()
            {
                currentEnemy.speed = self.warpFactor
            }
        }
        
        if self.backgroundImage.position.x < -self.backgroundImage.size.width
        {
            self.backgroundImage.position.x = self.backgroundImage2.position.x + self.backgroundImage2.size.width
        }
        if self.backgroundImage2.position.x < -self.backgroundImage2.size.width
        {
            self.backgroundImage2.position.x = self.backgroundImage.position.x + self.backgroundImage.size.width
        }
        
        if let currentEnemy = self.enemyLauncher.getCurrentEnemy()
        {
            if currentEnemy.position.x <= -currentEnemy.size.width
            {
                currentEnemy.removeFromParent()
                self.enemyLauncher.removeCurrentEnemy()
            }
        }
        else
        {
            let now = NSDate()
            if now.timeIntervalSinceDate(self.enemyLauncher.lastLaunch) > self.enemyLauncher.maxInterval
            {
                self.enemyLauncher.launchEnemy()
            }
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact)
    {
        print("Spaceship hit an enemy!!!")
    }
}
