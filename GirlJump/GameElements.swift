//
//  GameElements.swift
//  GirlJump
//
//  Created by apple on 08/04/2017.
//  Copyright © 2017 LIng. All rights reserved.
//

import SpriteKit

extension GameScene {
    
    func createBackground () -> SKNode {
        let backgroundNode = SKNode()
        let spacing =  64 * scaleFactor
        
        for index in 0 ... 19{
        let bground = SKSpriteNode(imageNamed:  String(format: "bground%02d", index + 1))
        bground.setScale(scaleFactor)
        bground.anchorPoint = CGPoint(x: 0.5, y: 0)
        bground.position = CGPoint(x: self.size.width / 2, y: spacing * CGFloat(index))
        backgroundNode.addChild(bground)
        }
        
        return backgroundNode
    }
    
    
   /* func createMidground () -> SKNode {
        let midgroundNode = SKNode()
        var anchor:CGPoint!
        var xPos:CGFloat!
        
        for index in 0 ... 9 {
            var name:String
            
            let randomNumber = arc4random() % 2
            
            if randomNumber > 0 {
                name = "cloudLeft"
                anchor = CGPoint(x: 0, y: 0.5)
                xPos = 0
            }else{
                name = "cloudRight"
                anchor = CGPoint(x: 1, y: 0.5)
                xPos = self.size.width
            }
            
            let cloudNode = SKSpriteNode(imageNamed: name)
            cloudNode.anchorPoint = anchor
            cloudNode.position = CGPoint(x: xPos, y: 500 * CGFloat(index))
            
            midgroundNode.addChild(cloudNode)
            
        }
        
        return midgroundNode
        
        
    } */
    
    
    func createPlayer() -> SKNode {
        
        let playerNode = SKNode()
        playerNode.position = CGPoint(x: self.size.width / 2, y: 80)
        
        let sprite = SKSpriteNode(imageNamed: "gitcat")
        playerNode.addChild(sprite)
        
        playerNode.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width / 2)
        
        playerNode.physicsBody?.dynamic = false
        playerNode.physicsBody?.allowsRotation = false
        
        playerNode.physicsBody?.restitution = 1
        playerNode.physicsBody?.friction = 0
        playerNode.physicsBody?.angularDamping = 0
        playerNode.physicsBody?.linearDamping = 0
        
        playerNode.physicsBody?.usesPreciseCollisionDetection = true
        
        playerNode.physicsBody?.categoryBitMask = CollisionBitMask.Player
        
        playerNode.physicsBody?.collisionBitMask = 0
        playerNode.physicsBody?.contactTestBitMask = CollisionBitMask.Item | CollisionBitMask.Brick
        
        
        return playerNode
        
        
    }
    
    func createPlatformAtPosition (postion:CGPoint, ofType type:LaptopType) -> LaptopNode {
        let node = LaptopNode()
        let position = CGPoint(x: postion.x * scaleFactor, y: postion.y)
        node.position = position
        node.name = "LAPTOPNODE"
        node.laptopType = type
        
        var sprite:SKSpriteNode
        
        if type == LaptopType.normalBrick {
            sprite = SKSpriteNode(imageNamed: "laptop")
            
        }else {
            sprite = SKSpriteNode(imageNamed: "computerbroken")
        }
        
        node.addChild(sprite)
        
        node.physicsBody = SKPhysicsBody(rectangleOfSize: sprite.size)
        node.physicsBody?.dynamic = false
        node.physicsBody?.categoryBitMask = CollisionBitMask.Brick
        node.physicsBody?.collisionBitMask = 0
        
        return node
        
        
        
    }
    
    
    
    func createItemAtPosition (postion:CGPoint, ofType type:ItemType) -> ItemNode {
        let node = ItemNode()
        let position = CGPoint(x: postion.x * scaleFactor, y: postion.y)
        node.position = position
        node.name = "ITEMNODE"
        node.itemType = type
        
        var sprite:SKSpriteNode
        
        if type == ItemType.NormalComputer {
            sprite = SKSpriteNode(imageNamed: "stackoverflow")
            
        }else {
            sprite = SKSpriteNode(imageNamed: "owl")
        }
        
        node.addChild(sprite)
        
        node.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width / 2)
        node.physicsBody?.dynamic = false
        node.physicsBody?.categoryBitMask = CollisionBitMask.Item
        node.physicsBody?.collisionBitMask = 0
        
        return node
        
        
    }
    
    
    
    
    
    
    
}

