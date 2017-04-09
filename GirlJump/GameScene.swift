//
//  GameScene.swift
//  GirlJump
//
//  Created by apple on 08/04/2017.
//  Copyright (c) 2017 LIng. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var background:SKNode!
    var midground:SKNode!
    var forefround:SKNode!
    
    var hud:SKNode!
    
    
    
    var player:SKNode!
    
    var scaleFactor:CGFloat!
    
    var startButton = SKSpriteNode(imageNamed: "helloworld")
    
    var endOfGamePosition = 0
    
    let motionManager = CMMotionManager()
    
    var xAcceleration:CGFloat = 0.0
    
    var scoreLabel:SKLabelNode!
    var itemLabel:SKLabelNode!
    
    var playersMaxY:Int!
    
    var gameOver = false
    
    var currentMaxY:Int!
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override init(size:CGSize) {
        super.init(size: size)
        
        backgroundColor = SKColor.whiteColor()
        
        let levelData = GameHandler.sharedInstance.levelData
        
        
        currentMaxY = 80
        GameHandler.sharedInstance.score = 0
        gameOver = false
        
        
        endOfGamePosition = levelData!["EndOfLevel"]!.integerValue
        
        
        scaleFactor = self.size.width / 320
        
        
        background = createBackground()
        addChild(background)
        
       // midground = createMidground()
        //addChild(midground)
        
        forefround = SKNode()
        addChild(forefround)
        
        
        hud = SKNode()
        addChild(hud)
        
        startButton.position = CGPoint(x: self.size.width / 2, y: 180)
        hud.addChild(startButton)
        
        
        let item = SKSpriteNode(imageNamed: "stackoverflow")
        item.position = CGPoint(x: 25, y: self.size.height-30)
        hud.addChild(item)
        
        
        itemLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        itemLabel.fontSize = 30
        itemLabel.fontColor = SKColor.whiteColor()
        itemLabel.position = CGPoint(x: 50, y: self.size.height-40)
        itemLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        
        
        itemLabel.text = "  \(GameHandler.sharedInstance.items)"
        //itemLabel.text = "0"
        hud.addChild(itemLabel)
        
        scoreLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        scoreLabel.fontSize = 30
        scoreLabel.fontColor = SKColor.whiteColor()
        scoreLabel.position = CGPoint(x: self.size.width-20, y: self.size.height-40)
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        
        scoreLabel.text = "0"
        hud.addChild(scoreLabel)
        
        
        
        
        
        player = createPlayer()
        forefround.addChild(player)
        
        let platforms = levelData["Platforms"] as! NSDictionary
        let platformPatterns = platforms["Patterns"] as! NSDictionary
        let platformPositions = platforms["Positions"] as! [NSDictionary]
        
        
        for platformPosition in platformPositions {
            let x = platformPosition["x"]?.floatValue
            let y = platformPosition["y"]?.floatValue
            let pattern = platformPosition["pattern"] as! NSString
            
            
            let platformPattern = platformPatterns[pattern] as! [NSDictionary]
            for platformPoint in platformPattern {
                let xValue = platformPoint["x"]?.floatValue
                let yValue = platformPoint["y"]?.floatValue
                let type = LaptopType(rawValue: platformPoint["type"]!.integerValue)
                let xPosition = CGFloat(xValue! + x!)
                let yPosition = CGFloat(yValue! + y!)
                
                let platformNode = createPlatformAtPosition(CGPoint(x: xPosition, y: yPosition), ofType: type!)
                forefround.addChild(platformNode)
            }
            
        }
        
        
        
        let items = levelData["Items"] as! NSDictionary
        let itemPatterns = items["Patterns"] as! NSDictionary
        let itemPositions = items["Positions"] as! [NSDictionary]
        
        
        for itemPosition in itemPositions {
            let x = itemPosition["x"]?.floatValue
            let y = itemPosition["y"]?.floatValue
            let pattern = itemPosition["pattern"] as! NSString
            
            
            let itemPattern = itemPatterns[pattern] as! [NSDictionary]
            for itemPoint in itemPattern {
                let xValue = itemPoint["x"]?.floatValue
                let yValue = itemPoint["y"]?.floatValue
                let type = ItemType(rawValue: itemPoint["type"]!.integerValue)
                let xPosition = CGFloat(xValue! + x!)
                let yPosition = CGFloat(yValue! + y!)
                
                let itemNode = createItemAtPosition(CGPoint(x: xPosition, y: yPosition), ofType: type!)
                forefround.addChild(itemNode)
            }
            
        }
        
        
        
        
        
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -2)
        physicsWorld.contactDelegate = self
        
        motionManager.accelerometerUpdateInterval = 0.2
        
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!) { (data:CMAccelerometerData?, error:NSError?) -> Void in
            if let accelerometerData = data {
                let acceleration = accelerometerData.acceleration
                self.xAcceleration = (CGFloat(acceleration.x) * 0.75 + (self.xAcceleration * 0.25))
            }
        }
        
        
        
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        var updateHUD = false
        
        var otherNode:SKNode!
        
        if contact.bodyA.node != player {
            otherNode = contact.bodyA.node
        }else{
            otherNode = contact.bodyB.node
        }
        
        updateHUD = (otherNode as! GenericNode).collisionWithPlayer(player)
        
        if updateHUD {
            itemLabel.text = "  \(GameHandler.sharedInstance.items)"
            scoreLabel.text = "\(GameHandler.sharedInstance.score)"
        }
        
        
    }
    
    override func didSimulatePhysics() {
        player.physicsBody?.velocity = CGVector(dx: xAcceleration * 400, dy: player.physicsBody!.velocity.dy)
        
        if player.position.x < -20 {
            player.position = CGPoint(x: self.size.width + 20, y: player.position.y)
        }else if (player.position.x > self.size.width + 20) {
            player.position = CGPoint(x: -20, y: player.position.y)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if player.physicsBody!.dynamic {
            return
        }
        
        startButton.removeFromParent()
        
        player.physicsBody?.dynamic = true
        
        player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        
        if gameOver {
            return
        }
        
        
        forefround.enumerateChildNodesWithName("LAPTOPNODE") { (node, stop) -> Void in
            let platform = node as! LaptopNode
            platform.shouldRemoveNode(self.player.position.y)
        }
        
        forefround.enumerateChildNodesWithName("ITEMNODE") { (node, stop) -> Void in
            let item = node as! ItemNode
            item.shouldRemoveNode(self.player.position.y)
        }
        
        
        if player.position.y > 200 {
            background.position = CGPoint(x: 0, y: -((player.position.y - 200)/10))
            forefround.position = CGPoint(x: 0, y: -((player.position.y - 200)))
        }
        
        
        if Int(player.position.y) > currentMaxY {
            GameHandler.sharedInstance.score += Int(player.position.y) - currentMaxY
            currentMaxY = Int(player.position.y)
            scoreLabel.text = "\(GameHandler.sharedInstance.score)"
            
        }
        
        if Int(player.position.y) > endOfGamePosition {
            endGame()
        }
        
        if Int(player.position.y) < currentMaxY - 800 {
            endGame()
        }
        
        
    }
    
    func endGame(){
        gameOver = true
        GameHandler.sharedInstance.saveGameStats()
        
        let transtion = SKTransition.fadeWithDuration(0.5)
        let endGameScene = EndGame(size: self.size)
        self.view?.presentScene(endGameScene, transition: transtion)
    }
}
