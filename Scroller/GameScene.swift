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
    var spaceship: Spaceship!
    var warpFactor: CGFloat = 1
    var currentTouch: UITouch?
    var lastForce: CGFloat = 0.0
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
        
        self.spaceship = Spaceship(scene: self)
        self.spaceship.zPosition = 1
        self.spaceship.position = CGPoint(x: CGRectGetMinX(self.screenRect) + 115, y: CGRectGetMidY(self.screenRect))
        self.addChild(self.spaceship)
        
        self.enemyLauncher = EnemyLauncher(scene: self)
        self.enemyLauncher.launchEnemy()
        
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
   
    override func update(currentTime: CFTimeInterval)
    {
        self.backgroundImage.checkBackgroundPosition()
        
        self.updateScores()
        
        if let currentTouch = self.spaceship.currentTouch
        {
            defer
            {
                if let currentGate = self.currentGate
                {
                    currentGate.speed = self.warpFactor
                }
                
                self.backgroundImage.setSpeed(self.warpFactor)
            }
            
            guard self.warpFactor <= 8 else
            {                
                return
            }
            
            if currentTouch.force == currentTouch.maximumPossibleForce
            {
                self.warpFactor += currentTouch.force * 0.003
                
                self.backgroundImage.setSpeed(self.warpFactor)
                
                self.lastForce = currentTouch.force
                
                return
            }
            else if currentTouch.force <= 1
            {
                self.warpFactor = 1
                
                self.lastForce = 0
            }
            else
            {
                if currentTouch.force > self.lastForce
                {
                    if currentTouch.force - self.lastForce > 1
                    {
                        self.warpFactor += self.lastForce * 0.003
                    }
                    else
                    {
                        self.warpFactor += currentTouch.force * 0.003
                    }
                }
                else if currentTouch.force < self.lastForce
                {
                    self.warpFactor -= self.lastForce * 0.003
                }
                
                self.lastForce = currentTouch.force
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
            print("Hit the gate!!!")
            self.gameOver()
        }
        else if gateObject.categoryBitMask == SKNode.ContactCategory.Target
        {
            print("Hit the target!!!")
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
