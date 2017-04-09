//
//  GameHandler.swift
//  GirlJump
//
//  Created by apple on 08/04/2017.
//  Copyright © 2017 LIng. All rights reserved.
//

import Foundation

class GameHandler {
    var score:Int
    var highScore:Int
    var items:Int
    
    var levelData:NSDictionary!
    
    class var sharedInstance:GameHandler {
        struct Singleton {
            static let instance = GameHandler()
        }
        
        return Singleton.instance
    }
    
    init(){
        score = 0
        highScore = 0
        items = 0
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        highScore = userDefaults.integerForKey("highScore")
      //  items = userDefaults.integerForKey("items")
        
        
        if let path = NSBundle.mainBundle().pathForResource("Level01", ofType: "plist") {
            if let level = NSDictionary(contentsOfFile: path) {
                levelData = level
            }
        }
        
        
    }
    
    func saveGameStats() {
       
        highScore = max(score,highScore)
        
        items = 0
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setInteger(highScore, forKey: "highScore")
        userDefaults.setInteger(items, forKey: "items")
        userDefaults.synchronize()
        
    }
}
