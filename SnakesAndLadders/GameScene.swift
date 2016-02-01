//
//  GameScene.swift
//  SnakesAndLadders
//
//  Created by Chris Archibald on 1/31/16.
//  Copyright (c) 2016 Chris Archibald. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameScene: SKScene {
    
    var board = SKSpriteNode()
    
    //Game State Variables
    var gamePlayInProgrss: Bool = false
    var player1Turn: Bool = false
    var rolling: Bool = false
    var moveFinished: Bool = true
    var gameOver: Bool = false
    
    //Player Positions
    var player1CurrentPosition: Int = 0
    var player2CurrentPosition: Int = 0
    
    //Rolled Dice
    var rolledDice: Int = 0
    
    //player Sprite Nodes
    var player1: SKSpriteNode = SKSpriteNode()
    var player2: SKSpriteNode = SKSpriteNode()
    
    //Player Current Position Labels
    var player1CurrentPositionLabel: SKLabelNode = SKLabelNode()
    var player2CurrentPositionLabel: SKLabelNode = SKLabelNode()
    
    // Status and tap Labels
    var statusLabel: SKLabelNode = SKLabelNode()
    var tapLabel: SKLabelNode = SKLabelNode()
    
    //Game Sounds
    var diceSFX: SKAction = SKAction()
    var snakeSFX: SKAction = SKAction()
    var ladderSFX: SKAction = SKAction()
    var backgoundMusic: AVAudioPlayer = AVAudioPlayer()
    var gameOverMusic: AVAudioPlayer = AVAudioPlayer()
    
    override func didMoveToView(view: SKView) {
        board = childNodeWithName("board") as! SKSpriteNode
        player1 = childNodeWithName("player1") as! SKSpriteNode
        player2 = childNodeWithName("player2") as! SKSpriteNode
        player1CurrentPositionLabel = childNodeWithName("player1CurrentPositionLabel") as! SKLabelNode
        player2CurrentPositionLabel = childNodeWithName("player2CurrentPositionLabel") as! SKLabelNode
        
        player1CurrentPositionLabel.text = "0"
        player2CurrentPositionLabel.text = "0"
        
        statusLabel = childNodeWithName("statusLabel") as! SKLabelNode
        tapLabel = childNodeWithName("tapLabel") as!SKLabelNode
        
        statusLabel.text = "Touch to start Game"
        tapLabel.text = "Tap to roll dice"
        
        let fadeOut = SKAction.fadeOutWithDuration(0.3)
        let fadeIn = SKAction.fadeInWithDuration(0.3)
        let sequence = SKAction.sequence([fadeOut, fadeIn])
        let repeatAction = SKAction.repeatActionForever(sequence)
        tapLabel.runAction(repeatAction)
        tapLabel.hidden = true
        
        setupSounds()
        
        backgoundMusic.play()
    }
    
    func setupSounds() {
        let url: NSURL = NSBundle.mainBundle().URLForResource("gameplaybackground", withExtension: "mp3")!
        
        do {
            backgoundMusic = try AVAudioPlayer(contentsOfURL: url)
        } catch _ {
            print("Error Loading Background Msuic")
        }
        
        backgoundMusic.numberOfLoops = -1
        backgoundMusic.prepareToPlay()
        
        let urlGameOver: NSURL = NSBundle.mainBundle().URLForResource("GameOver", withExtension: "mp3")!
        
        do {
            gameOverMusic = try AVAudioPlayer(contentsOfURL: urlGameOver)
        } catch _ {
            print("Error Loading Background Msuic")
        }
        
        gameOverMusic.numberOfLoops = 1
        gameOverMusic.prepareToPlay()
        
        diceSFX = SKAction.playSoundFileNamed("dice.caf", waitForCompletion: false)
        snakeSFX = SKAction.playSoundFileNamed("snake.caf", waitForCompletion: false)
        ladderSFX = SKAction.playSoundFileNamed("ladder.caf", waitForCompletion: false)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
