//
//  GameScene.swift
//  FlappyBird
//
//  Created by Reno & Jenny on 4/26/16.
//  Copyright (c) 2016 Reno & Jenny. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var bird = SKSpriteNode()
    var pipeUpTexture = SKTexture()
    var pipeDownTexture = SKTexture()
    var PipeMoveAndRemove = SKAction()
    let pipeGap = 110.0
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        //print(String(self.frame.size.width))
        //print(String(self.frame.size.height))
        //print(String(self.size.width))
        //print(String(self.size.height))
        
        // Physics
        self.physicsWorld.gravity = CGVectorMake(0.0, -4.0)
        
        
        // ground image
        let groundTexture = SKTexture(imageNamed: "ground")
        groundTexture.filteringMode = SKTextureFilteringMode.Nearest
        
        let groundImage = SKSpriteNode(texture: groundTexture)
        groundImage.setScale(2)
        groundImage.position = CGPointMake(groundImage.size.width / 1.2, groundImage.size.height / 2)
        self.addChild(groundImage)
        
        
        // ground physical body
        let groundBody = SKNode()
        groundBody.position = CGPointMake(0, 0)
        groundBody.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, groundImage.size.height * 2))
        groundBody.physicsBody?.dynamic = false
        self.addChild(groundBody)
        
        
        
        // background image
        let backgroundTexture = SKTexture(imageNamed: "background")
        backgroundTexture.filteringMode = SKTextureFilteringMode.Nearest
        
        let backgroundImage = SKSpriteNode(texture: backgroundTexture)
        backgroundImage.setScale(1)
        backgroundImage.position = CGPointMake(self.frame.size.width, groundImage.size.height / 2 + backgroundImage.size.height / 1.5 - 50)
        backgroundImage.zPosition = -10
        self.addChild(backgroundImage)
        
        // bird
        let birdTexture = SKTexture(imageNamed: "dogeicon")
        birdTexture.filteringMode = SKTextureFilteringMode.Linear
        
        
        bird = SKSpriteNode(texture: birdTexture)
        bird.setScale(0.35)
        bird.position = CGPoint(x: self.frame.size.width * 0.4, y: self.frame.size.height * 0.8)
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 2)
        bird.physicsBody?.dynamic = true
        bird.physicsBody?.allowsRotation = false
        self.addChild(bird)
        
        
        
        // pipe
        pipeUpTexture = SKTexture(imageNamed: "PipeUp")
        pipeDownTexture = SKTexture(imageNamed: "PipeDown")
        
        
        
        
        let distanceToMove = CGFloat(self.frame.size.width + 2 * pipeDownTexture.size().width)
        let movePipes = SKAction.moveByX(-distanceToMove, y: 0.0, duration: NSTimeInterval(3))
        let removePipes = SKAction.removeFromParent()
        PipeMoveAndRemove = SKAction.sequence([movePipes, removePipes])
        
        
        
        
        
        // spawn pipes
    
        let spawn = SKAction.runBlock({() in self.spawnPipes()})
        let delay = SKAction.waitForDuration(NSTimeInterval(2.0))
        let spawnThenDelay = SKAction.sequence([spawn, delay])
        let spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
        
        self.runAction(spawnThenDelayForever)

    }
    
    
    
    func spawnPipes() {
        
        let pipePair = SKNode()
        pipePair.position = CGPointMake(self.frame.size.width + pipeUpTexture.size().width, 0)
        pipePair.zPosition = -5
        
        let height = UInt32(self.frame.size.height / 4)
        //let y = arc4random() % height + height
        
        let pipeDown = SKSpriteNode(texture: pipeDownTexture)
        pipeDown.setScale(1)
        pipeDown.position = CGPointMake(0.0, self.frame.size.height / 1.1)
        
        pipeDown.physicsBody = SKPhysicsBody(rectangleOfSize: pipeDown.size)
        pipeDown.physicsBody?.dynamic = false
        pipePair.addChild(pipeDown)
        
        let pipeUp = SKSpriteNode(texture: pipeUpTexture)
        pipeUp.setScale(1)
        pipeUp.position = CGPointMake(0.0, CGFloat(pipeGap) + pipeUp.size.height)
        
        pipeUp.physicsBody = SKPhysicsBody(rectangleOfSize: pipeUp.size)
        pipeUp.physicsBody?.dynamic = false
        pipePair.addChild(pipeUp)
        
        pipePair.runAction(PipeMoveAndRemove)
        self.addChild(pipePair)
    }

    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            bird.physicsBody?.velocity = CGVectorMake(0,0)
            bird.physicsBody?.applyImpulse(CGVectorMake(0, 50))
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
