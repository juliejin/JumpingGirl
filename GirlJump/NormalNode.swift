//
//  NormalNode.swift
//  GirlJump
//
//  Created by apple on 08/04/2017.
//  Copyright © 2017 LIng. All rights reserved.
//

import SpriteKit

struct CollisionBitMask {
    static let Player:UInt32 = 0x00
    static let Item:UInt32 = 0x01
    static let Brick:UInt32 = 0x02
}


enum LaptopType:Int {
    case normalBrick = 0
    case breakableBrick = 1
}

class GenericNode: SKNode {
    
    
    func collisionWithPlayer (player:SKNode) -> Bool {
        return false
    }
    
    func shouldRemoveNode (playerY:CGFloat) {
        if playerY > self.position.y + 300 {
            self.removeFromParent()
        }
    }
    
    
}

