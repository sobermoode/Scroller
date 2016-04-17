//
//  ScoreLabel.swift
//  Scroller
//
//  Created by Aaron Justman on 4/16/16.
//  Copyright © 2016 AaronJ. All rights reserved.
//

import SpriteKit

class ScoreLabel: SKNode
{
    let scoreTextContainer = SKNode()
    let scoreContainer = SKNode()
    let scoreText = SKLabelNode(text: "Score:")
    let score = SKLabelNode(text: "0,000,000")
    
    override init()
    {
        super.init()
        
        self.scoreText.fontName = "SFUIDisplay-Bold"
        self.scoreTextContainer.addChild(self.scoreText)
        self.score.fontName = "SFUIDisplay-Bold"
        self.scoreContainer.addChild(self.score)
        self.scoreContainer.position.x = self.scoreTextContainer.position.x + self.scoreTextContainer.frame.width + 150
        
        self.zPosition = 2
        
        self.addChild(self.scoreTextContainer)
        self.addChild(self.scoreContainer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
