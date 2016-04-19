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
    let scoreText, score: SKLabelNode
    var total: Int = 0
    var currentScore: Int
    {
        return total
    }
    
    init(title: String)
    {
        self.scoreText = SKLabelNode(text: title)
        self.score = SKLabelNode(text: "\(self.total)")
        
        super.init()
        
        self.scoreText.fontName = "SFUIDisplay-Bold"
        self.scoreText.fontSize = 20
        self.scoreTextContainer.addChild(self.scoreText)
        self.score.fontName = "SFUIDisplay-Bold"
        self.score.fontSize = 20
        self.scoreContainer.addChild(self.score)
        self.scoreContainer.position.x = self.scoreTextContainer.position.x + self.scoreTextContainer.frame.width + 150
        
        self.zPosition = 2
        
        self.addChild(self.scoreTextContainer)
        self.addChild(self.scoreContainer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func increaseScore(value: Int)
    {
        self.total += value
        
        self.score.text = "\(self.total)"
    }
}
