//
//  GameScene.swift
//  Multitouch
//
//  Created by Joel Hollingsworth, Chris Gerencser, and Jared Schwartz on 10/20/17.
//  Copyright © 2017 Joel Hollingsworth. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    // used to build all of the other circles
    private var circleNode : SKShapeNode?
    
    var gv: GameViewController?
    
    // associative array tying UITouches to the circle on the screen
    var touchNodes = [UITouch:SKShapeNode]()
    
    // 5 colors for touch points (iPhone only allows 5 touches)
    let colors = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow, UIColor.orange]
    
    // called once
    override func didMove(to view: SKView) {
        
        // define the width of the circle (based on the screen size)
        let w = (self.size.width + self.size.height) * 0.12
        
        // create the circle
        circleNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w / 2.0)
        
        // set some properties on the circle
        circleNode?.lineWidth = 15.0
        circleNode?.isAntialiased = true
    }
    
    func createCircleForTouch(touch : UITouch) {
        
        // copy a circle, set its position, color, and add it to the scene
        if let n = self.circleNode?.copy() as! SKShapeNode? {
            n.position = touch.location(in: self)
            n.strokeColor = pickFirstColorNotInUse()
            self.addChild(n)
            
            // associate the touch with the circle
            touchNodes[touch] = n
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // loop over all touches, create a circle for that touch
        for touch in touches {
            createCircleForTouch(touch: touch)
        }
        if touchNodes.count == peopleCount {
            if gametype == 0 {
                pickOne(touches: touches)
            }
            if gametype == 1 {
                twoTeams(touches: touches)
            }
        }
        
    }
    
    func pickOne(touches : Set<UITouch>){
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            if self.touchNodes.count == peopleCount {
                let randomNumber = Int(arc4random_uniform(UInt32(peopleCount)) + 1)
                var touchNum = 1
                for touch in self.touchNodes.keys {
                    if touchNum != randomNumber {
                        self.removeCircleForTouch(touch: touch)
                    }
                    touchNum = touchNum + 1
                }
                self.scene?.backgroundColor = UIColor.white
                self.gameOver()
            }
        })
    }
    
    func gameOver(){
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
        sleep(5)
        self.removeFromParent()
        self.view?.presentScene(nil)
        self.gv?.dismiss(animated: true, completion: nil)
        })

    }
    
    func twoTeams(touches : Set<UITouch>){
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
             if self.touchNodes.count == peopleCount {
                var blueTeam = 0
                var redTeam = 0
                for circle in self.touchNodes.values{
                    let random = Int(arc4random_uniform(1))
                    if blueTeam == redTeam{
                        if random == 0 {
                            circle.strokeColor = UIColor.blue
                            blueTeam = blueTeam + 1
                        } else {
                            circle.strokeColor = UIColor.red
                            redTeam = redTeam + 1
                        }
                    } else {
                        if blueTeam > redTeam {
                            circle.strokeColor = UIColor.red
                            redTeam = redTeam + 1
                        } else {
                            circle.strokeColor = UIColor.blue
                            blueTeam = blueTeam + 1
                        }
                    }
                }
                self.scene?.backgroundColor = UIColor.white
                self.gameOver()
            }
        })
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            // get the circle associated with the touch
            if let circle = touchNodes[touch] {
                // move the circle to the new location.
                let newLocation = touch.location(in: self)
                circle.position = newLocation
            }
        }
        
    }
    
    func removeCircleForTouch (touch : UITouch ) {
        
        // if we can find the touch, remove the circle
        if let circle = touchNodes[touch] {
            circle.removeFromParent()               // remove from scene
            touchNodes.removeValue(forKey: touch)   // remove from array
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            removeCircleForTouch(touch: touch)
        }
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            removeCircleForTouch(touch: touch)
        }

    }
    
    // choose a color currently not in use
    func pickFirstColorNotInUse() -> UIColor {
        for color in colors {
            var colorInUse = false
            for touch in touchNodes {
                if touch.value.strokeColor == color {
                    colorInUse = true
                }
            }
            if !colorInUse {
                return color
            }
        }
        
        return UIColor.brown
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
