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
            player1.runAction(moveTo, completion: { () -> Void in
                self.player1CurrentPositionLabel.text = "\(Int(position))"
                
                if self.checkHit(currentPosition: self.player1CurrentPosition) == true {
                    switch(self.player1CurrentPosition) {
                    case 7, 20, 28, 38, 42, 51, 62, 71, 86:
                        self.runAction(self.ladderSFX)
                    default:
                        self.runAction(self.snakeSFX)
                    }
                    
                    self.move(player: 1, position: self.snakesAndLadders(currentPosition: self.player1CurrentPosition))
                    self.player1CurrentPosition = Int(self.snakesAndLadders(currentPosition: self.player1CurrentPosition))
                    return
                }
                
                if self.player1CurrentPosition == 100 {
                    self.gameIsOver(player: 1)
                    return
                }
                
                self.moveFinished = true
                self.player1Turn = false
                self.statusLabel.text = "Computer's Turn"
                
                let dice0 = self.childNodeWithName("dice")
                dice0?.removeFromParent()
                
                let delay = SKAction.waitForDuration(1.0)
                self.runAction(delay, completion: { () -> Void in
                    self.moveFinished = false
                    self.rollDice(player: 2)
                })
            })
            
        } else {
            let moveTo = SKAction.moveTo(CGPointMake(CGFloat(x), CGFloat(y)), duration: 1.0)
            player2.runAction(moveTo, completion: { () -> Void in
                self.player2CurrentPositionLabel.text = "\(Int(position))"
                
                if self.checkHit(currentPosition: self.player2CurrentPosition) == true {
                    switch(self.player2CurrentPosition) {
                    case 7, 20, 28, 38, 42, 51, 62, 71, 86:
                        self.runAction(self.ladderSFX)
                    default:
                        self.runAction(self.snakeSFX)
                    }
                    
                    self.move(player: 2, position: self.snakesAndLadders(currentPosition: self.player2CurrentPosition))
                    self.player2CurrentPosition = Int(self.snakesAndLadders(currentPosition: self.player2CurrentPosition))
                    return
                }
                
                if self.player2CurrentPosition == 100 {
                    self.gameIsOver(player: 2)
                    return
                }
                
                self.moveFinished = true
                self.player1Turn = true
                self.statusLabel.text = "Your Turn"
                self.tapLabel.hidden = false
                
                let dice0 = self.childNodeWithName("dice")
                dice0?.removeFromParent()
            })
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
    
    func gameIsOver(player player: Int) {
        tapLabel.hidden = true
        gameOverMusic.play()
        gameOver = true
        gamePlayInProgrss = true
        
        let gameOverLabel = SKLabelNode(fontNamed: "Arial Black")
        if player == 1 {
            gameOverLabel.text = "You Won"
        } else {
            gameOverLabel.text = "Computer Won"
        }
        gameOverLabel.fontSize = 45
        gameOverLabel.fontColor = SKColor.blueColor()
        gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.addChild(gameOverLabel)
        
        let scaleUp = SKAction.scaleTo(1.2, duration: 1.0)
        let scaleDown = SKAction.scaleTo(1.0, duration: 0.2)
        let sequence = SKAction.sequence([scaleUp, scaleDown])
        gameOverLabel.runAction(sequence, completion: { () -> Void in
            let label = SKLabelNode(fontNamed: "Chalkduster")
            label.position = CGPointMake(CGRectGetMidX(self.frame), 100)
            label.text = "Touch to restart"
            label.fontSize = 20
            label.fontColor = SKColor.greenColor()
            
            self.addChild(label)
            
            let fadeOut = SKAction.fadeOutWithDuration(0.3)
            let fadeIn = SKAction.fadeInWithDuration(0.3)
            let sequence = SKAction.sequence([fadeOut, fadeIn])
            let repeatAction = SKAction.repeatActionForever(sequence)
            
            label.runAction(repeatAction)
        })
        
        if NSUserDefaults.standardUserDefaults().objectForKey("SnakeGame") == nil {
            NSUserDefaults.standardUserDefaults().setObject("1", forKey: "SnakeGame")
            if player == 1 {
                NSUserDefaults.standardUserDefaults().setObject("0", forKey: "SnakeGameComp")
                NSUserDefaults.standardUserDefaults().setObject("1", forKey: "SnakeGameUser")
            } else {
                NSUserDefaults.standardUserDefaults().setObject("1", forKey: "SnakeGameComp")
                NSUserDefaults.standardUserDefaults().setObject("0", forKey: "SnakeGameUser")
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        } else {
            let totalgames: String = NSUserDefaults.standardUserDefaults().valueForKey("SnakeGame") as! String
            var totalgame: Int? = Int(totalgames)
            totalgame = totalgame! + 1
            
            NSUserDefaults.standardUserDefaults().setValue("\(totalgame!)", forKey: "SnakeGame")
            if player == 1 {
                let usergames: String = NSUserDefaults.standardUserDefaults().valueForKey("SnakeGameUser") as! String
                var usergame: Int? = Int(usergames)
                usergame = usergame! + 1
                NSUserDefaults.standardUserDefaults().setValue("\(usergame)", forKey: "SnakeGameUser")
            } else {
                let compgames: String = NSUserDefaults.standardUserDefaults().valueForKey("SnakeGameComp") as! String
                var compgame: Int? = Int(compgames)
                compgame = compgame! + 1
                NSUserDefaults.standardUserDefaults().setValue("\(compgame)", forKey: "SnakeGameComp")
            }
            
            NSUserDefaults.standardUserDefaults().synchronize()
        }
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
    
    func rollDice(player player: Int) {
        if gameOver == false {
            rolling = true
            self.enumerateChildNodesWithName("dice", usingBlock: { (diceNode: SKNode, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                diceNode.removeFromParent()
            })
            
            var diceImages = [SKTexture]()
            for var i = 0; i < 10; i++ {
                let imageNum = arc4random() % 6 + 1
                let imageName = "dice\(imageNum)"
                let diceRolled = SKTexture(imageNamed: imageName)
                diceImages.append(diceRolled)
                rolledDice = Int(imageNum)
            }
            
            let dice = SKSpriteNode(imageNamed: "dice1")
            if self.player1Turn == true {
                dice.position = CGPointMake(65, 380)
            } else {
                dice.position = CGPointMake(955, 380)
            }
            dice.name = "dice"
            self.addChild(dice)
            let diceAnimation = SKAction.animateWithTextures(diceImages, timePerFrame: 0.2)
            self.runAction(diceSFX)
            
            dice.runAction(diceAnimation, completion: { () -> Void in
                if self.player1Turn == true {
                    if (self.player1CurrentPosition + self.rolledDice) <= 100 {
                        let pos = Float(self.player1CurrentPosition + self.rolledDice)
                        self.move(player: 1, position: pos)
                        self.player1CurrentPosition += self.rolledDice
                    } else {
                        self.moveFinished = true
                        self.player1Turn = false
                        self.statusLabel.text = "Computer's Turn"
                        
                        let delay = SKAction.waitForDuration(1.0)
                        self.runAction(delay, completion: { () -> Void in
                            
                            self.moveFinished = false
                            self.rollDice(player: 2)
                        })
                    }
                } else {
                    if (self.player2CurrentPosition + self.rolledDice) <= 100 {
                        let pos = Float(self.player2CurrentPosition + self.rolledDice)
                        self.move(player: 2, position: pos)
                        self.player2CurrentPosition += self.rolledDice
                    } else {
                        self.moveFinished = true
                        self.player1Turn = true
                        self.statusLabel.text = "Your Turn"
                    }
                }
                self.rolling = false
            })
        }
    }
    
    func restart() {
        let scene = TitleScene(fileNamed: "TitleScene")
        self.view?.presentScene(scene)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        if gameOver == true {
            restart()
            return
        }
        
        if gamePlayInProgrss == true {
            if (player1Turn == true && rolling == false && moveFinished == true) {
                moveFinished = false
                rollDice(player: 1)
                tapLabel.hidden = true
            }
        } else {
            startGame()
        }
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
