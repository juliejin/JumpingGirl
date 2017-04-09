//
//  PlatformNode.swift
//  GirlJump
//
//  Created by apple on 08/04/2017.
//  Copyright © 2017 LIng. All rights reserved.
//

import SpriteKit

class LaptopNode: GenericNode {
    
    var laptopType:LaptopType!
    
    override func collisionWithPlayer(player: SKNode) -> Bool {
        if player.physicsBody?.velocity.dy < 0 {
            player.physicsBody?.velocity = CGVector(dx: player.physicsBody!.velocity.dx, dy: 250)
            
            if laptopType == LaptopType.breakableBrick {
                self.removeFromParent()
            }
            
        }
        
        return false
    }
    
    
}

