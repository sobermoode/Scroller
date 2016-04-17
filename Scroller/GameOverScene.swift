//
//  GameOverScene.swift
//  Scroller
//
//  Created by Aaron Justman on 4/16/16.
//  Copyright © 2016 AaronJ. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene
{
    init(size: CGSize, score: Int)
    {
        super.init(size: size)
        
        let scoreLabel = SKLabelNode(text: "Final score: \(score)")
        scoreLabel.fontName = "SFUIDisplay-Bold"
        scoreLabel.position.x = (size.width / 2) - (scoreLabel.frame.size.width / 2)
        scoreLabel.position.y = (size.height / 2) - (scoreLabel.frame.size.height / 2)
        
        self.addChild(scoreLabel)
        
        self.runAction(
            SKAction.sequence([
                SKAction.waitForDuration(2),
                SKAction.runBlock()
                {
                    let transition = SKTransition.flipHorizontalWithDuration(0.5)
                    let scene = GameScene(size: size)
                    self.view?.presentScene(scene, transition: transition)
                }])
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
