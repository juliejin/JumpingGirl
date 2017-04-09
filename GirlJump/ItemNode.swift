//
//  ComputerNode.swift
//  GirlJump
//
//  Created by apple on 08/04/2017.
//  Copyright © 2017 LIng. All rights reserved.
//


import SpriteKit

enum ItemType:Int {
    case NormalComputer = 0
    case SpecialComputer = 1
}

class ItemNode: GenericNode {
    
    var itemType:ItemType!
    
    override func collisionWithPlayer(player: SKNode) -> Bool {
        player.physicsBody?.velocity = CGVector(dx: player.physicsBody!.velocity.dx, dy: 400)
        
        GameHandler.sharedInstance.score += (itemType == ItemType.NormalComputer ? 20 : 100)
        GameHandler.sharedInstance.items += (itemType == ItemType.SpecialComputer ? 1 : 5)
        
        
        self.removeFromParent()
        
        return true
    }
    
}

