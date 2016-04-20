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
    var warpFactorLabel, gatesLabel, scoreLabel: ScoreLabel!
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
        
        self.createLabels()
        
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
        let spaceshipTexture = SKTexture(imageNamed: "Spaceship")
        let spaceshipSize = CGSize(width: spaceshipTexture.size().width * 0.15, height: spaceshipTexture.size().height * 0.225)
        self.spaceship.physicsBody = SKPhysicsBody(texture: spaceshipTexture, size: spaceshipSize)
        self.spaceship.physicsBody?.categoryBitMask = SKNode.ContactCategory.Spaceship
        self.spaceship.physicsBody?.contactTestBitMask = SKNode.ContactCategory.Gate | SKNode.ContactCategory.Target
        self.spaceship.physicsBody?.collisionBitMask = 0
        self.spaceship.physicsBody?.usesPreciseCollisionDetection = true
        self.spaceship.position = CGPoint(x: CGRectGetMinX((self.view?.bounds)!) + 115, y: CGRectGetMidY((self.view?.bounds)!))
        
        enemyLauncher = EnemyLauncher(scene: self, player: self.spaceship)
        enemyLauncher.launchEnemy()
        
        self.addChild(self.spaceship)
        
        self.backgroundImage.beginScrolling()
    }
    
    func createLabels()
    {
        let labelNode = SKNode()
        
        self.warpFactorLabel = ScoreLabel(title: "Warp Factor:")
        self.warpFactorLabel.name = "warpFactorLabel"
        self.warpFactorLabel.position = CGPointZero
        labelNode.addChild(self.warpFactorLabel)
        
        self.gatesLabel = ScoreLabel(title: "Gates:")
        self.gatesLabel.name = "gatesLabel"
        self.gatesLabel.position.x = self.warpFactorLabel.position.x + self.warpFactorLabel.frame.width + 175
        labelNode.addChild(self.gatesLabel)
        
        self.scoreLabel = ScoreLabel(title: "Score:", initialValue: 1000000)
        self.scoreLabel.name = "scoreLabel"
        self.scoreLabel.position.x = self.gatesLabel.position.x + self.gatesLabel.frame.width + 175
        labelNode.addChild(self.scoreLabel)
        
        labelNode.position.x = CGRectGetMidX(self.screenRect) - (labelNode.frame.size.width) - 125
        labelNode.position.y = CGRectGetMaxY(self.screenRect) - labelNode.frame.size.height - 25
        
        self.addChild(labelNode)
    }
    
    func updateScores()
    {
        self.scoreLabel.increaseScore(1 * Int(self.warpFactor))
        
        let roundedWarpFactor = round(self.warpFactor * 100) / 100
        self.warpFactorLabel.score.text = "\(roundedWarpFactor)"
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
        
        self.updateScores()
        
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
            self.currentGate?.turnGateOff()
            
            let points = 100 * Int(self.warpFactor)
            self.scoreLabel.increaseScore(points)
            
            Gate.increaseTargetsHit()
            self.gatesLabel.score.text = "\(Gate.targetsHit)"
        }
    }
    
    func gameOver()
    {
        Gate.resetTargetsHit()
        
        let transition = SKTransition.flipHorizontalWithDuration(0.5)
        let scene = GameOverScene(size: self.size, score: self.scoreLabel.currentScore)
        self.view?.presentScene(scene, transition: transition)
    }
}
