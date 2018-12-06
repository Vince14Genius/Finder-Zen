//
//  GameTutorialScene.swift
//  Finder Zen
//
//  Created by Vince14Genius on 2/22/16.
//  Copyright © 2016 Vince14Genius. All rights reserved.
//

import SpriteKit
import AVFoundation

var tutorialStage = 0

//Tutorial Scenes that give instructions

class TutorialTransfer: SKScene {
    let Background = SKSpriteNode(imageNamed: "Background")
    let colorblindButton = SKSpriteNode(imageNamed: "pausedbg")
    
    init(size: CGSize, stage: Int) {
        tutorialStage = stage
        super.init(size: size)
        backgroundColor = .black
        scaleMode = .aspectFit
        
        Background.position = CGPoint(x: 512, y: 384)
        Background.alpha = 0.5
        Background.zPosition = 1
        addChild(Background)
        
        let clickToContinue = SKLabelNode(/*fontNamed: NSFont.systemFont(ofSize: 114514).fontName*/)
        clickToContinue.text = NSLocalizedString("CtoC", comment: "Click to continue. ")
        clickToContinue.fontSize = 32
        clickToContinue.position = CGPoint(x: 512, y: 32)
        clickToContinue.zPosition = 2
        addChild(clickToContinue)
        
        let label1 = SKNode()
        label1.position = CGPoint(x: 512, y: 512)
        labelSetup("", parent: label1, size: 48, y: 0)
        addChild(label1)
        
        let label2 = SKNode()
        label2.position = CGPoint(x: 512, y: 384)
        labelSetup("", parent: label2, size: 48, y: 0)
        addChild(label2)
        
        let label3 = SKNode()
        label3.position = CGPoint(x: 512, y: 256)
        labelSetup("", parent: label3, size: 48, y: 0)
        addChild(label3)
        
        colorblindButton.size = CGSize(width: 640, height: 64)
        colorblindButton.zPosition = 2
        colorblindButton.position = CGPoint(x: 512, y: 128)
        colorblindButton.alpha = 0.75
        labelSetup(NSLocalizedString("CtoCB", comment: "Click here to play the tutorial in colorblind mode. "), parent: colorblindButton, size: 32, y: -16)
        
        run(.run({bgm.volume = 0}))
        
        switch stage {
        case 1:
            let logo = SKSpriteNode(imageNamed: "Title")
            logo.zPosition = 2
            label2.addChild(logo)
            (label3.children[0] as! SKLabelNode).text = NSLocalizedString("TheTutorial", comment: "The Tutorial")
            addChild(colorblindButton)
            clickToContinue.text = NSLocalizedString("CtoPN", comment: "Click anywhere else to play the tutorial normally. ")
        case 2:
            (label1.children[0] as! SKLabelNode).text = NSLocalizedString("2_1", comment: "This is Finder, you need to protect him. ")
            let Finder = SKSpriteNode(imageNamed: "Finder")
            Finder.zPosition = 2
            Finder.xScale = 1.28
            Finder.yScale = 1.28
            label3.addChild(Finder)
        case 3:
            if colorblindMode {
                (label1.children[0] as! SKLabelNode).text = NSLocalizedString("3_1", comment: "The (O) bubble gives you 1 point")
            } else {
                (label1.children[0] as! SKLabelNode).text = NSLocalizedString("3_2", comment: "The blue bubble gives you 1 point")
            }
            (label2.children[0] as! SKLabelNode).text = NSLocalizedString("3_3", comment: "when it reaches Finder. ")
            (label3.children[0] as! SKLabelNode).text = NSLocalizedString("3_4", comment: "Let it pass through. ")
        case 5:
            if colorblindMode {
                (label1.children[0] as! SKLabelNode).text = NSLocalizedString("5_1", comment: "The (X) bubble is lethal")
            } else {
                (label1.children[0] as! SKLabelNode).text = NSLocalizedString("5_2", comment: "The red bubble is lethal")
            }
            (label2.children[0] as! SKLabelNode).text = NSLocalizedString("5_3", comment: "and it targets Finder. ")
            (label3.children[0] as! SKLabelNode).text = NSLocalizedString("5_4", comment: "Click on it to destroy it. ")
        case 7:
            if colorblindMode {
                (label1.children[0] as! SKLabelNode).text = NSLocalizedString("7_1", comment: "The (!) bubble damages Finder")
            } else {
                (label1.children[0] as! SKLabelNode).text = NSLocalizedString("7_2", comment: "The yellow bubble damages Finder")
            }
            (label2.children[0] as! SKLabelNode).text = NSLocalizedString("7_3", comment: "when you click on it. ")
            (label3.children[0] as! SKLabelNode).text = NSLocalizedString("7_4", comment: "Let it pass through. ")
        case 9:
            if colorblindMode {
                (label1.children[0] as! SKLabelNode).text = NSLocalizedString("9_1", comment: "The star bubble temporarily clears off")
            } else {
                (label1.children[0] as! SKLabelNode).text = NSLocalizedString("9_2", comment: "The green bubble temporarily clears off")
            }
            (label2.children[0] as! SKLabelNode).text = NSLocalizedString("9_3", comment: "all harmful stuff")
            (label3.children[0] as! SKLabelNode).text = NSLocalizedString("9_4", comment: "and grants you 10 points. ")
        case 10:
            if colorblindMode {
                (label1.children[0] as! SKLabelNode).text = NSLocalizedString("10_1", comment: "Click on the star bubble")
            } else {
                (label1.children[0] as! SKLabelNode).text = NSLocalizedString("10_2", comment: "Click on the green bubble")
            }
            (label2.children[0] as! SKLabelNode).text = NSLocalizedString("10_3", comment: "to activate it. ")
        case 12:
            (label1.children[0] as! SKLabelNode).text = NSLocalizedString("12_1", comment: "Now try protecting Finder")
            (label2.children[0] as! SKLabelNode).text = NSLocalizedString("12_2", comment: "until he earns 30 points. ")
        default:
            (label1.children[0] as! SKLabelNode).text = NSLocalizedString("Default_1", comment: "You have completed the tutorial!")
            (label2.children[0] as! SKLabelNode).text = NSLocalizedString("Default_2", comment: "You can re-visit the tutorial ")
            (label3.children[0] as! SKLabelNode).text = NSLocalizedString("Default_3", comment: "by clicking on the Finder Zen logo. ")
        }
    }
    
    func inputBegan(_ point: CGPoint) {
        let clickedNode = atPoint(point)
        if clickedNode === colorblindButton || clickedNode.parent === colorblindButton {
            clickedButton = colorblindButton
            colorblindButton.run(.scale(to: 1.2, duration: 0.1))
        } else {
            clickedButton = Background
        }
    }
    
    func inputEnded(_ point: CGPoint) {
        colorblindButton.run(.scale(to: 1.0, duration: 0.1))
        let clickedNode = atPoint(point)
        if (clickedNode === colorblindButton || clickedNode.parent === colorblindButton) && clickedButton === colorblindButton {
            colorblindButton.run(.scale(to: 1.0, duration: 0.1))
            colorblindMode = true
            standardDefaults.set(colorblindMode, forKey: "colorblindMode")
            standardDefaults.synchronize()
            if !muteSFX {
                run(.playSoundFileNamed("continue.mp3", waitForCompletion: false))
            }
            tutorialStage += 1
            view!.presentScene(TutorialTransfer(size: size, stage: tutorialStage), transition: .push(with: .left, duration: 0.5))
        } else if clickedButton === Background {
            switch tutorialStage {
            case 1, 2, 9:
                if !muteSFX {
                    run(.playSoundFileNamed("continue.mp3", waitForCompletion: false))
                }
                tutorialStage += 1
                view!.presentScene(TutorialTransfer(size: size, stage: tutorialStage), transition: .push(with: .left, duration: 0.5))
            case 12:
                if !muteSFX {
                    run(.playSoundFileNamed("continue.mp3", waitForCompletion: false))
                }
                tutorialStage += 1
                view!.presentScene(TutorialGameplay(size: CGSize(width: 800, height: 600)), transition: .fade(withDuration: 1.0))
            case 14:
                standardDefaults.set(true, forKey: "completedTutorial")
                view!.presentScene(GameTitleScene(size: size), transition: .fade(withDuration: 1.0))
            default:
                if !muteSFX {
                    run(.playSoundFileNamed("continue.mp3", waitForCompletion: false))
                }
                tutorialStage += 1
                view!.presentScene(TutorialLive(size: CGSize(width: 800, height: 600), stage: tutorialStage), transition: .fade(withDuration: 1.0))
            }
        }
        
        clickedButton = Background
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//Tutorial Scenes that involve live interactions

class TutorialLive: SKScene {
    
    let reds = SKNode()
    let blues = SKNode()
    let yellows = SKNode()
    let greens = SKNode()
    let effects = SKNode()
    
    let BackgroundNode = SKSpriteNode(imageNamed: "Background")
    let Finder = SKSpriteNode(imageNamed: "Finder")
    let tap = SKSpriteNode(imageNamed: "tap")
    var score = 100
    
    func gameWon() {
        if !muteSFX {
            self.run(.playSoundFileNamed("win.mp3", waitForCompletion: false))
        }
        tutorialStage += 1
        self.view!.presentScene(TutorialTransfer(size: CGSize(width: 1024, height: 768), stage: tutorialStage), transition: .fade(withDuration: 1.0))
    }
    
    func gameOver() {
        if !muteSFX {
            run(.playSoundFileNamed("lose.mp3", waitForCompletion: false))
        }
        tutorialStage -= 1
        run(.run {
            self.view!.presentScene(TutorialTransfer(size: CGSize(width: 1024, height: 768), stage: tutorialStage), transition: .fade(with: .red, duration: 1.0))
            })
    }
    
    func spawnRed() { //This function spawns a red ball, ending the game if not tapped.
        let ball = SKSpriteNode(imageNamed: "BubbleRed")
        if colorblindMode {ball.texture = SKTexture(imageNamed: "BubbleRed2")}
        ball.position = ballRand()
        reds.addChild(ball)
        ballMotion(ball)
        ball.run(.move(to: Finder.position,
            duration: 2.00
            ), completion: {self.gameOver()})
    }
    
    func spawnBlue() { //This function spawns a blue ball, adding a point if not tapped.
        let ball = SKSpriteNode(imageNamed: "BubbleBlue")
        if colorblindMode {ball.texture = SKTexture(imageNamed: "BubbleBlue2")}
        ball.position = ballRand()
        blues.addChild(ball)
        ballMotion(ball)
        if !muteSFX {
            ball.run(.sequence([.move(to: Finder.position,
                duration: 1.75
                ), .playSoundFileNamed("point.mp3", waitForCompletion: false), .run({self.addOne()}), .removeFromParent()]))
        } else {
            ball.run(.sequence([.move(to: Finder.position,
                duration: 1.75
                ), .run({self.addOne()}), .removeFromParent()]))
        }
    }
    
    func spawnGreen() { //This function spawns a green ball, clearing the screen if tapped on.
        if score >= 10 {
            let ball = SKSpriteNode(imageNamed: "BubbleGreen")
            if colorblindMode {ball.texture = SKTexture(imageNamed: "BubbleGreen2")}
            let startingPlace = ballRand()
            ball.position = startingPlace
            let endX = -(startingPlace.x - 400) + 400
            let endY = -(startingPlace.y - 300) + 300
            greens.addChild(ball)
            ballMotion(ball)
            ball.run(.sequence([.move(to: CGPoint(x: endX, y: endY),
                duration: 2.00
                ), .removeFromParent()]))
        }
    }
    
    func spawnYellow() { //This function spawns a yellow ball, ending the game if tapped on.
        if score >= 25 {for _ in 1...2 {
            let ball = SKSpriteNode(imageNamed: "BubbleYellow")
            if colorblindMode {ball.texture = SKTexture(imageNamed: "BubbleYellow2")}
            ball.position = ballRand()
            yellows.addChild(ball)
            ballMotion(ball)
            ball.run(.sequence([.move(to: ballRand(),
                duration: 2.25
                ), .removeFromParent()]))
            }
        }
    }
    
    func addOne() { //Triggers a blue bubble point-collect.
        Finder.run(.sequence([.scale(to: 1.2, duration: 0.15), .run({
            self.score += 1
        }), .scale(to: 1.0, duration: 0.15)]))
    }
    
    func addTen() { //Triggers a green bubble power-up.
        Finder.run(.repeat(.sequence([.rotate(byAngle: -3.1415926, duration: 0.1), .run({
            self.reds.removeAllChildren()
            self.yellows.removeAllChildren()
            self.score += 1
        })]), count: 10))
    }
    
    func addPoof(_ name: String, position: CGPoint, duration: TimeInterval) { //This function generates a particle effect for popped bubbles.
        let poof = SKEmitterNode(fileNamed: name)!
        poof.position = position
        effects.addChild(poof)
        poof.run(.sequence([.wait(forDuration: duration), .fadeOut(withDuration: duration), .removeFromParent()]))
    }

    init(size: CGSize, stage: Int) {
        tutorialStage = stage
        super.init(size: size)
        
        Finder.position = CGPoint(x: 400, y: 150)
        BackgroundNode.position = CGPoint(x: 400, y: 300)
        tap.position = CGPoint(x: -100, y: -100)
        
        scaleMode = .aspectFit
        BackgroundNode.zPosition = 1
        addChild(BackgroundNode)
        Finder.zPosition = 2
        addChild(Finder)
        reds.zPosition = 4
        addChild(reds)
        blues.zPosition = 5
        addChild(blues)
        yellows.zPosition = 6
        addChild(yellows)
        greens.zPosition = 7
        addChild(greens)
        effects.zPosition = 8
        addChild(effects)
        tap.zPosition = 9
        addChild(tap)
        
        run(.run({bgm.volume = 0}))
        
        switch tutorialStage {
        case 4: //[Live] Blue Bubble
            spawnBlue()
            run(.wait(forDuration: 2.25), completion: {
                if self.score == 101 {
                    self.gameWon()
                } else {
                    self.gameOver()
                }
            })
        case 6: //[Live] Red Bubble
            spawnRed()
            run(.wait(forDuration: 2.50), completion: {
                self.gameWon()
            })
        case 8: //[Live] Yellow Bubble
            spawnYellow()
            run(.wait(forDuration: 2.75), completion: {
                self.gameWon()
            })
        default: //[Live] Red Bubble, Yellow Bubble, Green Bubble
            spawnRed()
            spawnYellow()
            spawnGreen()
            run(.wait(forDuration: 3.50), completion: {
                if self.score == 110 {
                    self.gameWon()
                } else {
                    self.gameOver()
                }
            })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func directInput(_ point: CGPoint) {
        
        for node in greens.children {
            let distance = distanceTest(point, node.position)
            if distance <= 60 {
                addPoof("GreenPoof", position: node.position, duration: 0.5)
                node.removeFromParent()
                reds.removeAllChildren()
                yellows.removeAllChildren()
                if !muteSFX {run(SKAction.playSoundFileNamed("power.mp3", waitForCompletion: false))}
                addTen()
            }
        }
        
        for node in reds.children {
            let distance = distanceTest(point, node.position)
            if distance <= 60 {
                addPoof("RedPoof", position: node.position, duration: 0.2)
                node.removeFromParent()
                if !muteSFX {run(SKAction.playSoundFileNamed("blast.mp3", waitForCompletion: false))}
            }
        }
        
        for node in blues.children {
            let distance = distanceTest(point, node.position)
            if distance <= 60 {
                addPoof("BluePoof", position: node.position, duration: 0.2)
                node.removeFromParent()
                if !muteSFX {run(SKAction.playSoundFileNamed("blast.mp3", waitForCompletion: false))}
            }
        }
        
        for node in yellows.children {
            let distance = distanceTest(point, node.position)
            if distance <= 60 {
                addPoof("YellowPoof", position: node.position, duration: 0.2)
                node.removeFromParent()
                gameOver()
            }
        }
        
        tap.position = point
        tap.run(.fadeOut(withDuration: 0.25), completion: {self.tap.position = CGPoint(x: -100, y: -100); self.tap.alpha = 1})
    }
    
    func inputBegan(_ point: CGPoint) {
        if !menuOn {
            directInput(point)
        }
    }
}

//The Tutorial Scene that involves Casual Mode gameplay.

class TutorialGameplay: SKScene {
    let gameFrame = GamePlayScene(size: CGSize(width: 800, height: 600), mode: .casual)
    
    override init(size: CGSize) {
        super.init(size: size)
        scaleMode = .aspectFit
        addChild(gameFrame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func inputBegan(_ point: CGPoint) {
        gameFrame.inputBegan(point)
    }
    
    override func update(_ currentTime: TimeInterval) {
        gameFrame.update(currentTime)
        if gameFrame.score == 30 {
            gameFrame.score += 1
            run(.playSoundFileNamed("win.mp3", waitForCompletion: false))
            tutorialStage += 1
            view!.presentScene(TutorialTransfer(size: CGSize(width: 1024, height: 768), stage: tutorialStage), transition: SKTransition.fade(withDuration: 1.0))
        }
    }
}

#if os(iOS)
    
    extension TutorialTransfer {
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            if let touch = touches.first {
                inputBegan(touch.location(in: self))
            }
        }
        
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            if let touch = touches.first {
                inputEnded(touch.location(in: self))
            }
        }
        
    }
    
    extension TutorialLive {
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            if let touch = touches.first {
                inputBegan(touch.location(in: self))
            }
        }
        
    }
    
    extension TutorialGameplay {
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            if let touch = touches.first {
                inputBegan(touch.location(in: self))
            }
        }
        
    }
    
#endif

#if os(OSX)
    
    extension TutorialTransfer {
        
        override func mouseDown(with theEvent: NSEvent) {
            inputBegan(theEvent.location(in: self))
        }
        
        override func mouseUp(with theEvent: NSEvent) {
            inputEnded(theEvent.location(in: self))
        }
        
    }
    
    extension TutorialLive {
        
        override func mouseDown(with theEvent: NSEvent) {
            inputBegan(theEvent.location(in: self))
        }
        
    }
    
    extension TutorialGameplay {
        
        override func mouseDown(with theEvent: NSEvent) {
            inputBegan(theEvent.location(in: self))
        }
        
        override func keyDown(with theEvent: NSEvent) {
            gameFrame.keyDown(with: theEvent)
        }
        
    }
    
#endif
