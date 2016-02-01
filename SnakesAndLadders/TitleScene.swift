//
//  TitleScene.swift
//  SnakesAndLadders
//
//  Created by Chris Archibald on 1/31/16.
//  Copyright © 2016 Chris Archibald. All rights reserved.
//

import UIKit
import SpriteKit

class TitleScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let gameScene = GameScene(fileNamed: "GameScene")
        let transition = SKTransition.doorwayWithDuration(1.0)
        self.view?.presentScene(gameScene!, transition: transition)
    }
}
