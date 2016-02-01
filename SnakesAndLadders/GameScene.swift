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
        /* Setup your scene here */
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
