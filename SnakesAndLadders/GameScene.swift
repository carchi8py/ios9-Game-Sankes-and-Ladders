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
    
    // Check when a player lander on ladder or snake
    func checkHit(currentPosition currentPosition: Int) -> Bool {
        var returnValue: Bool = false
        switch (currentPosition) {
        case 7, 20, 25, 28, 36, 42, 51, 56, 59, 62, 69, 71, 83, 86, 91, 94, 99:
            returnValue = true
            break
        default:
            returnValue = false
            break
        }
        return returnValue
    }
    
    // Move the players to a positions (1 = You, 2 = Computer)
    func move(player player: Int, position: Float) {
        let row: Int = Int(ceil(position / 10.0))
        var col: Int  = 0
        
        if row  % 2 != 0 {
            if position > 10 {
                col = Int(position) - (row-1) * 10
            } else {
                col = Int(position)
            }
        } else {
            let colPos: Int = Int(position) - ((row - 1) * 10)
            
            switch(colPos) {
            case 1:
                col = 10
                break
            case 2:
                col = 9
                break
            case 3:
                col = 8
                break
            case 4:
                col = 7
                break
            case 5:
                col = 6
                break
            case 6:
                col = 5
                break
            case 7:
                col = 4
                break
            case 8:
                col = 3
                break
            case 9:
                col = 2
                break
            case 10:
                col = 1
                break
            default:
                break
            }
        }
        
        let colMinus: Float = Float(col - 1)
        let rowMinus: Float = Float(row - 1)
        
        let cellWidth: Float = Float(board.frame.width / 10.0)
        let xOffset = board.position.x
        let yOffset = board.position.y
        
        let x: Float = Float(xOffset) + colMinus * cellWidth + cellWidth/2
        let y: Float = Float(yOffset) + rowMinus * cellWidth + cellWidth/2
        
        if player == 1{
            let moveTo = SKAction.moveTo(CGPointMake(CGFloat(x), CGFloat(y)), duration: 1.0)
            player1.runAction(moveTo)
            
        } else {
            let moveTo = SKAction.moveTo(CGPointMake(CGFloat(x), CGFloat(y)), duration: 1.0)
            player2.runAction(moveTo)
        }
    }

    //finding a new position when hit == true
    func snakesAndLadders(currentPosition currentPosition: Int) -> Float {
        var newPosition = -1
        switch(currentPosition) {
        case 7:
            newPosition = 11
            break
        case 20:
            newPosition = 38
            break
        case 25:
            newPosition = 3
            break
        case 28:
            newPosition = 65
            break
        case 36:
            newPosition = 44
            break
        case 42:
            newPosition = 63
            break
        case 51:
            newPosition = 67
            break
        case 56:
            newPosition = 48
            break
        case 59:
            newPosition = 1
            break
        case 62:
            newPosition = 81
            break
        case 69:
            newPosition = 32
            break
        case 71:
            newPosition = 90
            break
        case 83:
            newPosition = 57
            break
        case 86:
            newPosition = 97
            break
        case 91:
            newPosition = 73
            break
        case 94:
            newPosition = 26
            break
        case 99:
            newPosition = 80
            break
        default:
            break
        }
        return Float(newPosition)
    
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
    
    func startGame() {
        let turn = arc4random() % 2 + 1
        switch(turn) {
        case 1:
            statusLabel.text = "Your Turn"
            player1Turn = true
            tapLabel.hidden = false
            break
        case 2:
            statusLabel.text = "Computer Turn"
            player1Turn = false
            moveFinished = false
            rollDice(player: 2)
            break
        default :
            break
        }
        
        gamePlayInProgrss = true
        gameOver = false
    }
    
    func restart() {
        let scene = TitleScene(fileNamed: "TitleScene")
        self.view?.presentScene(scene)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
