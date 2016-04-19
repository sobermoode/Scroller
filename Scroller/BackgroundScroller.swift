//
//  BackgroundScroller.swift
//  Scroller
//
//  Created by Aaron Justman on 4/18/16.
//  Copyright © 2016 AaronJ. All rights reserved.
//

import SpriteKit

struct BackgroundScroller
{
    var image, image2: SKSpriteNode
    var duration: NSTimeInterval
    var warpFactor: CGFloat = 1
    var scene: SKScene
    let screenRect: CGRect = UIScreen.mainScreen().bounds
    
    init(imageName: String, duration: NSTimeInterval, inScene scene: SKScene)
    {        
        self.image = SKSpriteNode(imageNamed: imageName)
        self.image2 = SKSpriteNode(imageNamed: imageName)
        
        let xFactor: CGFloat = self.screenRect.width / self.image.size.width
        let yFactor: CGFloat = self.screenRect.height / self.image.size.height
        
        self.image.xScale = xFactor
        self.image.yScale = yFactor
        self.image.anchorPoint = CGPoint(x: 0, y: 0)
        self.image.zPosition = 0
        self.image.position = CGPoint(x: CGRectGetMinX(self.screenRect), y: CGRectGetMinY(self.screenRect))
        
        self.image2.xScale = xFactor
        self.image2.yScale = yFactor
        self.image2.anchorPoint = CGPoint(x: 0, y: 0)
        self.image2.zPosition = 0
        self.image2.position = CGPoint(x: self.image.size.width, y: self.image.position.y)
        
        self.duration = duration
        self.scene = scene
    }
    
    func beginScrolling()
    {
        let scroll = SKAction.moveByX(-self.image.size.width * self.warpFactor, y: 0, duration: self.duration)
        let continuousScroll = SKAction.repeatActionForever(scroll)
        
        self.image.runAction(continuousScroll)
        self.image2.runAction(continuousScroll)
        
        self.scene.addChild(image)
        self.scene.addChild(image2)
    }
    
    func setSpeed(speed: CGFloat)
    {
        self.image.speed = speed
        self.image2.speed = speed
    }
    
    mutating func setWarpFactor(warpFactor: CGFloat)
    {
        self.warpFactor = warpFactor
    }
    
    func checkBackgroundPosition()
    {
        if self.image.position.x <= -self.image.size.width
        {
            self.image.position.x = self.image2.position.x + self.image2.size.width
        }
        if self.image2.position.x <= -self.image2.size.width
        {
            self.image2.position.x = self.image.position.x + self.image.size.width
        }
    }
}