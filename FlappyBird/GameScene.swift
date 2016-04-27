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
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        print(String(self.frame.size.width))
        print(String(self.frame.size.height))
        print(String(self.size.width))
        print(String(self.size.height))
        
        // Physics
        self.physicsWorld.gravity = CGVectorMake(0.0, -4.0)
        
        
        // ground image
        let groundTexture = SKTexture(imageNamed: "background")
        groundTexture.filteringMode = SKTextureFilteringMode.Nearest
        
        var groundImage = SKSpriteNode()
        groundImage = SKSpriteNode(texture: groundTexture)
        groundImage.setScale(0.8)
        groundImage.position = CGPoint(x: self.size.width / 2, y: groundImage.size.height / 2)
        self.addChild(groundImage)
        
        
        // ground physical body
        var groundBody = SKNode()
        groundBody.position = CGPointMake(0, 0)
        groundBody.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, self.frame.size.height * 0.44))
        groundBody.physicsBody?.dynamic = false
        self.addChild(groundBody)
        
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
