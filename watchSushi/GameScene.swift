//
//  GameScene.swift
//  SushiTower
//
//  Created by Parrot on 2019-02-14.
//  Copyright © 2019 Parrot. All rights reserved.
//

import SpriteKit
import GameplayKit
import WatchConnectivity
import FirebaseDatabase



class GameScene: SKScene, WCSessionDelegate
{
    var tappedOn : String = ""
    var numbRandomGen : Int = 0
    var increaseTime : String = ""
    var pauseStatus : String = ""
    var score : Int = 0
    var namee: String = ""
//    var a: String = ""
    let scorePrint = SKLabelNode(fontNamed: "Chalkduster")
    
    
    
    
    
    var ref: DatabaseReference!
    
    
    var levelTimerLabel = SKLabelNode(fontNamed: "ArialMT")
    
    var levelTimerValue: Int = 25
    {
        didSet
        {
            levelTimerLabel.text = "Time left: \(levelTimerValue)"
        }
    }
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?)
    {
        if WCSession.isSupported()
        {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession)
    {
    }
    
    func sessionDidDeactivate(_ session: WCSession)
    {
    }

    
    func removeShushi()
    {
        let pieceToRemove = self.sushiTower.first
        let stickToRemove = self.chopstickGraphicsArray.first
        
        if (pieceToRemove != nil && stickToRemove != nil)
        {
            pieceToRemove!.removeFromParent()
            self.sushiTower.remove(at: 0)
            
            stickToRemove!.removeFromParent()
            self.chopstickGraphicsArray.remove(at:0)
            
            self.chopstickPositions.remove(at:0)
            
            for piece in sushiTower
            {
                piece.position.y = piece.position.y - SUSHI_PIECE_GAP
            }
            
            for stick in chopstickGraphicsArray
            {
                stick.position.y = stick.position.y - SUSHI_PIECE_GAP
            }
        }
    }
    
    
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any])
    {
        



        print("Message received on Phone is: \(message)")
        self.tappedOn = message["tapped"] as! String
        self.increaseTime = message["increaseTimer"] as! String
        self.pauseStatus = message["pause"] as! String
        self.namee = message["name"] as! String
        
        if(pauseStatus == "true")
        {
            self.removeAction(forKey: "countdown")
        }
        else
        {
            if(tappedOn == "left")
            {
                cat.position = CGPoint(x:self.size.width*0.25, y:100)
                let facingRight = SKAction.scaleX(to: 1, duration: 0)
                self.cat.run(facingRight)
                self.catPosition = "left"
                score = score + 1
                let image1 = SKTexture(imageNamed: "character1")
                let image2 = SKTexture(imageNamed: "character2")
                let image3 = SKTexture(imageNamed: "character3")
                
                let punchTextures = [image1, image2, image3, image1]
                
                let punchAnimation = SKAction.animate(
                    with: punchTextures,
                    timePerFrame: 0.1)
                
                self.cat.run(punchAnimation)
                removeShushi()
            }
            if(tappedOn == "right")
            {
                cat.position = CGPoint(x:self.size.width*0.75, y:100)
                let facingLeft = SKAction.scaleX(to: -1, duration: 0)
                self.cat.run(facingLeft)
                self.catPosition = "right"
                score = score + 1
                let image1 = SKTexture(imageNamed: "character1")
                let image2 = SKTexture(imageNamed: "character2")
                let image3 = SKTexture(imageNamed: "character3")
                
                let punchTextures = [image1, image2, image3, image1]
                
                let punchAnimation = SKAction.animate(
                    with: punchTextures,
                    timePerFrame: 0.1)
                
                self.cat.run(punchAnimation)
                removeShushi()
            }
            if(increaseTime == "true")
            {
                self.levelTimerValue = self.levelTimerValue + 10;
            }
            if(namee != "false")
            {
                self.ref.child("user/name").setValue(self.namee)
                self.ref.child("user/score").setValue(self.score)
            }
        }
    }
    
    
    let cat = SKSpriteNode(imageNamed: "character1")
    let sushiBase = SKSpriteNode(imageNamed:"roll")
    var sushiTower:[SKSpriteNode] = []
    let SUSHI_PIECE_GAP:CGFloat = 80
    
    var chopstickGraphicsArray:[SKSpriteNode] = []
    
    var catPosition = "left"
    var chopstickPositions:[String] = []
    
    
    
    
    func spawnSushi()
    {
        let sushi = SKSpriteNode(imageNamed:"roll")
        
        if (self.sushiTower.count == 0)
        {
            sushi.position.y = sushiBase.position.y
                + SUSHI_PIECE_GAP
            sushi.position.x = self.size.width*0.5
        }
        else
        {
            let previousSushi = sushiTower[self.sushiTower.count - 1]
            sushi.position.y = previousSushi.position.y + SUSHI_PIECE_GAP
            sushi.position.x = self.size.width*0.5
        }
        
        addChild(sushi)
        
        self.sushiTower.append(sushi)
        
        
        let stickPosition = Int.random(in: 1...2)
        print("Random number: \(stickPosition)")
        if (stickPosition == 1)
        {
            self.chopstickPositions.append("right")
            
            let stick = SKSpriteNode(imageNamed:"chopstick")
            stick.position.x = sushi.position.x + 100
            stick.position.y = sushi.position.y - 10
            addChild(stick)
            
            self.chopstickGraphicsArray.append(stick)
            
            let facingRight = SKAction.scaleX(to: -1, duration: 0)
            stick.run(facingRight)
        }
        else if (stickPosition == 2)
        {
            self.chopstickPositions.append("left")
            
            let stick = SKSpriteNode(imageNamed:"chopstick")
            stick.position.x = sushi.position.x - 100
            stick.position.y = sushi.position.y - 10
            addChild(stick)
            
            self.chopstickGraphicsArray.append(stick)
        }
    }
    
    
    
    override func didMove(to view: SKView)
    {
        ref = Database.database().reference()

        if (WCSession.isSupported() == true)
        {
            print("WC is supported!")
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        else
        {
            print("WC NOT supported!")
        }
        levelTimerLabel.fontColor = SKColor.yellow
        levelTimerLabel.fontSize = 20
        levelTimerLabel.position = CGPoint(x: size.width/5, y: size.height/2 + 250)
        levelTimerLabel.text = "Time left: \(levelTimerValue)"
        addChild(levelTimerLabel)
        
        scorePrint.text = "Score: \(score)"
        scorePrint.horizontalAlignmentMode = .right
        scorePrint.position = CGPoint(x: 150, y: 600)
        scorePrint.fontColor = UIColor.red
        addChild(scorePrint)
        
        
        
        
        
        
        let wait = SKAction.wait(forDuration: 1.0)
        let block = SKAction.run({
            [unowned self] in
            if self.levelTimerValue > 0
            {
                self.scorePrint.text = "Score: \(self.score)"
                self.levelTimerValue -= 1
                if self.levelTimerValue % 5 == 0
                {
                    var randomNumber = Int.random(in: 0 ... 1)
                    
                    if(randomNumber == 1)
                    {
                        self.numbRandomGen += 1
                        if(self.numbRandomGen < 3)
                        {
                            let time = ["powerUp" : "true", "time" : self.levelTimerValue] as [String : Any]
                            WCSession.default.sendMessage(time, replyHandler:nil)
                        }
                    }
                    else
                    {
                        let time = ["powerUp" : "false", "time" : self.levelTimerValue] as [String : Any]
                        WCSession.default.sendMessage(time, replyHandler:nil)
                    }
                }
                else
                {
                    let time = ["powerUp" : "false", "time" : self.levelTimerValue] as [String : Any]
                    WCSession.default.sendMessage(time, replyHandler:nil)
                }
            }
            else
            {
                self.removeAction(forKey: "countdown")
                let time = ["powerUp" : "false", "time" : self.levelTimerValue] as [String : Any]
                WCSession.default.sendMessage(time, replyHandler:nil)
            }
        })
        
        let sequence = SKAction.sequence([wait,block])
        run(SKAction.repeatForever(sequence), withKey: "countdown")
        
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = -1
        addChild(background)
        
        cat.position = CGPoint(x:self.size.width*0.25, y:100)
        addChild(cat)
        
        sushiBase.position = CGPoint(x:self.size.width*0.5, y: 100)
        addChild(sushiBase)
        
        self.buildTower()
    }
    
    func buildTower()
    {
        for _ in 0...20
        {
            self.spawnSushi()
        }
        for i in 0...20
        {
            print(self.chopstickPositions[i])
        }
        
    }
    
    
    override func update(_ currentTime: TimeInterval)
    {
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let mousePosition = touches.first?.location(in: self) else
        {
            return
        }
        
        print(mousePosition)
      
        
        let pieceToRemove = self.sushiTower.first
        let stickToRemove = self.chopstickGraphicsArray.first
        
        if (pieceToRemove != nil && stickToRemove != nil)
        {
            pieceToRemove!.removeFromParent()
            self.sushiTower.remove(at: 0)
            
            stickToRemove!.removeFromParent()
            self.chopstickGraphicsArray.remove(at:0)
            
            self.chopstickPositions.remove(at:0)
            
            for piece in sushiTower
            {
                piece.position.y = piece.position.y - SUSHI_PIECE_GAP
            }
            
            for stick in chopstickGraphicsArray
            {
                stick.position.y = stick.position.y - SUSHI_PIECE_GAP
            }
        }
        
        let middleOfScreen  = self.size.width / 2
        if (mousePosition.x < middleOfScreen)
        {
            print("TAP LEFT")
            cat.position = CGPoint(x:self.size.width*0.25, y:100)
            let facingRight = SKAction.scaleX(to: 1, duration: 0)
            self.cat.run(facingRight)
            self.catPosition = "left"
        }
        else
        {
            print("TAP RIGHT")
            cat.position = CGPoint(x:self.size.width*0.85, y:100)
            let facingLeft = SKAction.scaleX(to: -1, duration: 0)
            self.cat.run(facingLeft)
            self.catPosition = "right"
        }
       
        let image1 = SKTexture(imageNamed: "character1")
        let image2 = SKTexture(imageNamed: "character2")
        let image3 = SKTexture(imageNamed: "character3")
        
        let punchTextures = [image1, image2, image3, image1]
        
        let punchAnimation = SKAction.animate(
            with: punchTextures,
            timePerFrame: 0.1)
        
        self.cat.run(punchAnimation)
    
        
        let firstChopstick = self.chopstickPositions[0]
        if (catPosition == "left" && firstChopstick == "left")
        {
            print("Cat Position = \(catPosition)")
            print("Stick Position = \(firstChopstick)")
            print("Conclusion = LOSE")
            print("------")
        }
        else if (catPosition == "right" && firstChopstick == "right")
        {
            print("Cat Position = \(catPosition)")
            print("Stick Position = \(firstChopstick)")
            print("Conclusion = LOSE")
            print("------")
        }
        else if (catPosition == "left" && firstChopstick == "right")
        {
            print("Cat Position = \(catPosition)")
            print("Stick Position = \(firstChopstick)")
            print("Conclusion = WIN")
            print("------")
            
        }
        else if (catPosition == "right" && firstChopstick == "left")
        {
            print("Cat Position = \(catPosition)")
            print("Stick Position = \(firstChopstick)")
            print("Conclusion = WIN")
            print("------")
        }
    }
    
}
