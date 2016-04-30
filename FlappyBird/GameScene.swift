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
    var groundTexture = SKTexture()
    var pipeUpTexture = SKTexture()
    var pipeDownTexture = SKTexture()
    var PipeMoveAndRemove = SKAction()
    let pipeGap:CGFloat = 130.0
    var pauseButton = SKSpriteNode()
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        
        // Physics
        self.physicsWorld.gravity = CGVectorMake(0.0, -4.5)
        
        // pause button
        let pauseButtonTexture = SKTexture(imageNamed: "pause")
        pauseButton = SKSpriteNode(texture: pauseButtonTexture)
        pauseButton.setScale(0.5)
        pauseButton.position = CGPointMake(self.frame.size.width / 1.5, self.frame.size.height / 1.1)
        pauseButton.zPosition = 5
        pauseButton.name = "pause"
        self.addChild(pauseButton)
        
        
        // ground image
        groundTexture = SKTexture(imageNamed: "ground")
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
        let movePipes = SKAction.moveByX(-distanceToMove, y: 0.0, duration: NSTimeInterval(3.0))
        let removePipes = SKAction.removeFromParent()
        PipeMoveAndRemove = SKAction.sequence([movePipes, removePipes])
        
        
        
        
        
        // spawn pipes
    
        let spawn = SKAction.runBlock({() in self.spawnPipes()})
        let delay = SKAction.waitForDuration(NSTimeInterval(1.5))
        let spawnThenDelay = SKAction.sequence([spawn, delay])
        let spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
        
        self.runAction(spawnThenDelayForever)

    }
    
    
    
    func spawnPipes() {
        
        let pipePair = SKNode()
        pipePair.position = CGPointMake(self.frame.size.width + pipeUpTexture.size().width, 0)
        pipePair.zPosition = -5
        
        
        let pipeUp = SKSpriteNode(texture: pipeUpTexture)
        pipeUp.setScale(2)
        let height = UInt32(pipeUp.size.height / 2)
        let y = arc4random() % height + height
        pipeUp.position = CGPointMake(0.0, CGFloat(y))
        
        pipeUp.physicsBody = SKPhysicsBody(rectangleOfSize: pipeUp.size)
        pipeUp.physicsBody?.dynamic = false
        pipePair.addChild(pipeUp)
        
        
        let pipeDown = SKSpriteNode(texture: pipeDownTexture)
        pipeDown.setScale(2)
        pipeDown.position = CGPointMake(0.0, CGFloat(y) + CGFloat(pipeDown.size.height) + pipeGap)
        
        pipeDown.physicsBody = SKPhysicsBody(rectangleOfSize: pipeDown.size)
        pipeDown.physicsBody?.dynamic = false
        pipePair.addChild(pipeDown)
        
        
        pipePair.runAction(PipeMoveAndRemove)
        self.addChild(pipePair)
    }

    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            let node = nodeAtPoint(location)
            
            if node.name == "resume" {
                
            }
            
            if node.name == "pause" {
                // pause game and and blur filter
                self.paused = true
                let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
                let blurEffectView = UIVisualEffectView(effect: blurEffect)
                blurEffectView.frame = (self.scene?.view?.bounds)!
                blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
                self.scene?.view?.addSubview(blurEffectView)
                
                
                // add doge to pause view
                let doge = UIImage(named: "doge_original")
                let pauseDoge = UIImageView(image: doge)
                let x1 = self.view!.bounds.width / 2 - doge!.size.width / 4
                let y1 = self.view!.bounds.height / 2 - doge!.size.height / 4
                pauseDoge.frame = CGRectMake(x1, y1 - self.view!.bounds.height / 10, doge!.size.width / 2, doge!.size.height / 2)
                pauseDoge.contentMode = UIViewContentMode.ScaleAspectFit
                
                
                // add resume button
                let resume = UIImage(named: "play")
                let resumeButton = UIImageView(image: resume)
                let x2 = self.view!.bounds.width / 2 - resume!.size.width / 4
                let y2 = self.view!.bounds.height / 2 - resume!.size.height / 4
                resumeButton.frame = CGRectMake(x2, y2 + self.view!.bounds.height / 10 , resume!.size.width / 2, resume!.size.height / 2)
                resumeButton.contentMode = UIViewContentMode.ScaleAspectFit
                
                
                
                // animation
                pauseDoge.alpha = CGFloat(0.0)
                resumeButton.alpha = CGFloat(0.0)
                self.view?.addSubview(pauseDoge)
                self.view?.addSubview(resumeButton)
                UIView.animateWithDuration(0.7, delay: 0.2, options: UIViewAnimationOptions.CurveLinear, animations: {
                    pauseDoge.alpha = CGFloat(0.9)
                    resumeButton.alpha = CGFloat(0.9)
                    }, completion: nil)
                
            }
            
            bird.physicsBody?.velocity = CGVectorMake(0,0)
            bird.physicsBody?.applyImpulse(CGVectorMake(0, 55))
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
