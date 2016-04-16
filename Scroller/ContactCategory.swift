//
//  ContactCategory.swift
//  Scroller
//
//  Created by Aaron Justman on 4/16/16.
//  Copyright © 2016 AaronJ. All rights reserved.
//

import SpriteKit

extension SKNode
{
    struct ContactCategory
    {
        static let None: UInt32 = 0
        static let Gate: UInt32 = 0b1
        static let Target: UInt32 = 0b10
        static let Spaceship: UInt32 = 0b100
    }
}