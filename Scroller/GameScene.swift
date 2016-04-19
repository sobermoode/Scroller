//
//  GameScene.swift
//  Scroller
//
//  Created by Aaron Justman on 4/12/16.
//  Copyright (c) 2016 AaronJ. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate
{
    var backgroundImage: BackgroundScroller!
    var spaceship: SKSpriteNode!
    var warpFactor: CGFloat = 1
    var currentTouch: UITouch?
    var sustainedSpeed: Int = 0
    var enemyLauncher: EnemyLauncher!
    var scoreLabel = ScoreLabel()
    var currentGate: Gate?
    let screenRect: CGRect = UIScreen.mainScreen().bounds
    
    override init(size: CGSize)
    {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView)
    {
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        self.physicsWorld.contactDelegate = self
        
        self.scoreLabel.position.x = CGRectGetMaxX(self.screenRect) - self.scoreLabel.calculateAccumulatedFrame().width
        self.scoreLabel.position.y = CGRectGetMaxY(self.screenRect) - self.scoreLabel.calculateAccumulatedFrame().height
        
        self.backgroundImage = BackgroundScroller(imageName: "Background", duration: 7, inScene: self)
        
        self.spaceship = SKSpriteNode(imageNamed: "Spaceship")
        self.spaceship.xScale = 0.15
        self.spaceship.yScale = 0.225
        self.spaceship.zRotation = -1.57
        self.spaceship.zPosition = 1
        let xRange = SKRange(lowerLimit: CGRectGetMinX(self.screenRect) + (self.spaceship.size.width / 2), upperLimit: CGRectGetMaxX(self.screenRect) - (self.spaceship.size.width / 2))
        let yRange = SKRange(lowerLimit: CGRectGetMinY(self.screenRect) + (self.spaceship.size.height / 2), upperLimit: CGRectGetMaxY(self.screenRect) - (self.spaceship.size.height / 2))
        let xConstraint = SKConstraint.positionX(xRange)
        let yConstraint = SKConstraint.positionY(yRange)
        self.spaceship.constraints = [xConstraint, yConstraint]
        self.spaceship.physicsBody = SKPhysicsBody(rectangleOfSize: self.spaceship.size)
        self.spaceship.physicsBody?.categoryBitMask = SKNode.ContactCategory.Spaceship
        self.spaceship.physicsBody?.contactTestBitMask = SKNode.ContactCategory.Gate | SKNode.ContactCategory.Target
        self.spaceship.physicsBody?.collisionBitMask = 0
        self.spaceship.physicsBody?.usesPreciseCollisionDetection = true
        self.spaceship.position = CGPoint(x: CGRectGetMinX((self.view?.bounds)!) + 115, y: CGRectGetMidY((self.view?.bounds)!))
        
        enemyLauncher = EnemyLauncher(scene: self, player: self.spaceship)
        enemyLauncher.launchEnemy()
        
        self.addChild(self.scoreLabel)
        self.addChild(self.spaceship)
        
        self.backgroundImage.beginScrolling()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        if let touch = touches.first
        {
            guard self.spaceship.containsPoint(touch.locationInNode(self)) else
            {
                return
            }
            
            self.spaceship.position.x += self.spaceship.size.width + 15
            
            self.currentTouch = touch
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        if let currentTouch = self.currentTouch
        {
            self.spaceship.position.x = currentTouch.locationInNode(self).x + self.spaceship.size.width + 15
            self.spaceship.position.y = currentTouch.locationInNode(self).y
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.currentTouch = nil
        self.warpFactor = 1
        self.backgroundImage.setSpeed(self.warpFactor)
        self.sustainedSpeed = 0
    }
   
    override func update(currentTime: CFTimeInterval)
    {
        self.backgroundImage.checkBackgroundPosition()
        
        self.scoreLabel.increaseScore(1 * Int(self.warpFactor))
        
        if let currentTouch = self.currentTouch
        {
            defer
            {
                if let currentGate = self.currentGate
                {
                    currentGate.speed = self.warpFactor
                }
            }
            
            guard self.warpFactor <= 8 else
            {                
                return
            }
            
            if currentTouch.force == currentTouch.maximumPossibleForce
            {
                self.warpFactor += currentTouch.force * 0.003
                
                self.backgroundImage.setSpeed(self.warpFactor)
                
                return
            }
            else if currentTouch.force <= 1
            {
                self.warpFactor = 1
            }
            else if currentTouch.force > 1
            {
                self.warpFactor += currentTouch.force * 0.003
                
                self.backgroundImage.setSpeed(self.warpFactor)
            }
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact)
    {
        var gateObject: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask
        {
            gateObject = contact.bodyA
        }
        else
        {
            gateObject = contact.bodyB
        }
        
        if gateObject.categoryBitMask == SKNode.ContactCategory.Gate
        {
            self.gameOver()
        }
        else if gateObject.categoryBitMask == SKNode.ContactCategory.Target
        {
            self.currentGate?.didHitGate = true
            
            let points = 100 * Int(self.warpFactor)
            self.scoreLabel.increaseScore(points)
        }
    }
    
    func gameOver()
    {
        let transition = SKTransition.flipHorizontalWithDuration(0.5)
        let scene = GameOverScene(size: self.size, score: self.scoreLabel.currentScore)
        self.view?.presentScene(scene, transition: transition)
    }
}
