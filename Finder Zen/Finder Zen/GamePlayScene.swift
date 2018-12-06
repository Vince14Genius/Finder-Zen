//
//  GamePlayScene.swift
//  Finder Zen
//
//  Created by Vince14Genius on 10/10/15.
//  Copyright © 2015 Vince14Genius. All rights reserved.
//

import SpriteKit
import AVFoundation

let keyCodeEsc: UInt16 = 53

func ballMotion(_ ball: SKSpriteNode) { // Pure eye candy (wiggling motion of bubbles)
    //ball.run(.repeatForever(.sequence([.scale(to: 1.1, duration: Double(arc4random() % 10) / 20 + 0.5), .scale(to: 0.9, duration: Double(arc4random() % 10) / 20 + 0.5)])))
    ball.run(.repeatForever(.sequence([.scale(to: 1.1, duration: 1.3), .scale(to: 0.9, duration: 1.3)])))
}

func ballRand() -> CGPoint { // This function provides the ball's position and target.
    let randomChance = arc4random() % 3
    let randomHeight = CGFloat(arc4random() % 450) + 150
    let randomWidth = CGFloat(arc4random() % 800)
    var x = CGFloat(0)
    var y = CGFloat(0)
    switch randomChance {
    case 0:
        x = -20
        y = randomHeight
    case 1:
        x = 820
        y = randomHeight
    case 2:
        x = randomWidth
        y = 580
    default:break
    }
    return CGPoint(x: x, y: y)
}

class GamePlayScene: SKScene {
    let mode: GameMode
    var timeAdder: TimeInterval
    
    let BackgroundNode = SKSpriteNode(imageNamed: "Background")
    let Finder = SKSpriteNode(imageNamed: "Finder")
    let tap = SKSpriteNode(imageNamed: "tap")
    let menuOnButton = SKSpriteNode(imageNamed: "BubblePurple3")
    
    var score = 0
    var record = 0
    let reds = SKNode()
    let blues = SKNode()
    let yellows = SKNode()
    let greens = SKNode()
    let effects = SKNode()
    
    let scoreLabel = SKLabelNode()
    let recordLabel = SKLabelNode()
    
    var timeElapsed: TimeInterval = 0
    var lastSpawnBallTime: TimeInterval = 0
    var oldTime = 0 // Helps refresh each second
    var oldFrameScore = "0" // Used to protect the score from cheats.
    
    init(size: CGSize, mode: GameMode) {
        self.mode = mode
        
        switch mode {
        case .casual: timeAdder = 0.75
        case .normal: timeAdder = 0.25
        case .deadly: timeAdder = -0.25
        }
        
        record = standardDefaults.integer(forKey: "record\(mode)")
        
        scoreLabel.text = "0"
        scoreLabel.fontSize = 48
        scoreLabel.fontColor = .black
        scoreLabel.fontName = NSFont.systemFont(ofSize: 114514).fontName
        
        let modeLabel = SKLabelNode(fontNamed: NSFont.systemFont(ofSize: 114514).fontName)
        let modeText: String
        switch mode {
        case .casual: modeText = NSLocalizedString("Casual", comment: "Casual")
        case .normal: modeText = NSLocalizedString("Normal", comment: "Normal")
        case .deadly: modeText = NSLocalizedString("Deadly", comment: "Deadly")
        }
        modeLabel.text = NSLocalizedString("ModeText", comment: "Mode: ") + "\(modeText)"
        modeLabel.fontSize = 24
        modeLabel.fontColor = .black
        
        recordLabel.text = NSLocalizedString("RecordText", comment: "Record: ") + "\(record)"
        recordLabel.fontSize = 24
        recordLabel.fontColor = .black
        recordLabel.fontName = NSFont.systemFont(ofSize: 114514).fontName
        
        BackgroundNode.size = CGSize(width: 800, height: 600)
        
        BackgroundNode.position = CGPoint(x: 400, y: 300)
        Finder.position = CGPoint(x: 400, y: 150)
        menuOnButton.position = CGPoint(x: 64, y: 64)
        scoreLabel.position = CGPoint(x: 400, y: 50)
        recordLabel.position = CGPoint(x: 200, y: 50)
        modeLabel.position = CGPoint(x: 600, y: 50)
        
        tap.position = CGPoint(x: -100, y: -100)
        
        super.init(size: size)
        scaleMode = .aspectFit
        
        BackgroundNode.zPosition = 1
        addChild(BackgroundNode)
        Finder.zPosition = 2
        addChild(Finder)
        menuOnButton.zPosition = 10
        addChild(menuOnButton)
        scoreLabel.zPosition = 10
        addChild(scoreLabel)
        recordLabel.zPosition = 10
        addChild(recordLabel)
        modeLabel.zPosition = 10
        addChild(modeLabel)
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
        
        do {
            try bgm = AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "bgm", withExtension: "mp3")!)
        } catch {
            fatalError("Failed to init AVAudioPlayer. ")
        }
        
        // Pure eye candies (wiggling motion of background and Finder)
        BackgroundNode.run(.repeatForever(.sequence([.scale(to: 1.25, duration: 1.50 + timeAdder), .scale(to: 1.0, duration: 1.50 + timeAdder)])))
        if #available(OSX 10.11, *) { // The "breathing" motion of Finder does not work well on OS X Yosemite
            //Finder.run(.repeatForever(.sequence([.scale(to: 1.05, duration: Double(arc4random() % 20) / 20 + 1), .scale(to: 0.95, duration: Double(arc4random() % 10) / 20 + 0.5)])))
            Finder.run(.repeatForever(.sequence([.scale(to: 1.1, duration: 1.3), .scale(to: 0.9, duration: 1.3)])))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func GameOver(_ cause: DeathCause) {
        let color: SKColor
        switch cause {
        case .red: color = deathRed
        case .yellow: color = deathYellow
        }
        
        if let skView = view {
            skView.presentScene(GameOverScene(size: CGSize(width: 1024, height: 768), score: score, mode: mode, deathCause: cause), transition: .fade(with: color, duration: 1.0))
        } else {
            parent!.run(.playSoundFileNamed("lose.mp3", waitForCompletion: false))
            tutorialStage -= 1
            run(.run {
                self.parent!.scene!.view!.presentScene(TutorialTransfer(size: CGSize(width: 1024, height: 768), stage: tutorialStage), transition: .fade(with: .red, duration: 1.0))
                })
        }
    }
    
    func addDifficulty() {
        if CGFloat(Int(CGFloat(score) / 4.0)) == CGFloat(score) / 4.0 { // Check if score is divisible by 4 after adding a point
            if timeAdder > -0.74 {
                timeAdder -= 0.01
            }
        }
    }
    
    func addOne() { // Triggers a blue bubble point-collect.
        Finder.run(.sequence([.scale(to: 1.2, duration: 0.15), .run({
            self.score += 1
            self.addDifficulty()
        }), .scale(to: 1.0, duration: 0.15)]))
    }
    
    func addTen() { // Triggers a green bubble power-up.
        Finder.run(.repeat(.sequence([.rotate(byAngle: -3.1415926, duration: 0.1), .run({
            self.reds.removeAllChildren()
            self.yellows.removeAllChildren()
            self.score += 1
            self.addDifficulty()
        })]), count: 10))
    }
    
    func spawnRed() { // This function spawns a red ball, ending the game if not tapped.
        let ball = SKSpriteNode(imageNamed: "BubbleRed")
        if colorblindMode {ball.texture = SKTexture(imageNamed: "BubbleRed2")}
        ball.position = ballRand()
        reds.addChild(ball)
        ballMotion(ball)
        ball.run(.move(to: Finder.position,
            duration: 1.50 + timeAdder //Change this number to tweak the red ball's lifespan.
            ), completion: {self.GameOver(.red)})
    }
    
    func spawnBlue() { // This function spawns a blue ball, adding a point if not tapped.
        let ball = SKSpriteNode(imageNamed: "BubbleBlue")
        if colorblindMode {ball.texture = SKTexture(imageNamed: "BubbleBlue2")}
        ball.position = ballRand()
        blues.addChild(ball)
        ballMotion(ball)
        if !muteSFX {
            ball.run(.sequence([.move(to: Finder.position,
                duration: 1.25 + timeAdder // Change this number to tweak the blue ball's lifespan.
                ), .playSoundFileNamed("point.mp3", waitForCompletion: false), .run({self.addOne()}), .removeFromParent()]))
        } else {
            ball.run(.sequence([.move(to: Finder.position,
                duration: 1.25 + timeAdder //Change this number to tweak the blue ball's lifespan.
                ), .run({self.addOne()}), .removeFromParent()]))
        }
    }
    
    func spawnGreen() { // This function spawns a green ball, clearing the screen if tapped on.
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
    
    func spawnYellow() { // This function spawns a yellow ball, ending the game if tapped on.
        let amountYellow: Int
        switch mode {
        case .casual: amountYellow = 2
        case .normal: amountYellow = 4
        case .deadly: amountYellow = 6
        }
        
        if score >= 25 {for _ in 1...amountYellow {
            let ball = SKSpriteNode(imageNamed: "BubbleYellow")
            if colorblindMode {ball.texture = SKTexture(imageNamed: "BubbleYellow2")}
            ball.position = ballRand()
            yellows.addChild(ball)
            ballMotion(ball)
            ball.run(.sequence([.move(to: ballRand(),
                duration: 1.75 + timeAdder
                ), .removeFromParent()]))
            }
        }
    }
    
    func spawnBall() { // This function spawns random balls.
        let randomChance = arc4random() % 8
        spawnBlue()
        switch randomChance {
        case 2: spawnRed()
        case 3: spawnRed()
        case 4: spawnRed(); spawnYellow()
        case 5: spawnRed(); spawnYellow()
        case 6: spawnRed(); spawnYellow()
        case 7: spawnRed(); spawnYellow(); spawnGreen()
        default:break
        }
    }
    
    func addPoof(_ name: String, position: CGPoint, duration: TimeInterval) { // This function generates a particle effect for popped bubbles.
        let poof = SKEmitterNode(fileNamed: name)!
        poof.position = position
        poof.targetNode = self
        poof.particleZPosition = 2.1
        effects.addChild(poof)
        poof.run(.sequence([
            .wait(forDuration: 0.1),
            .run {
                poof.particleBirthRate = 0
            },
            .wait(forDuration: 1),
            .removeFromParent()
        ]))
    }

    func directInput(_ point: CGPoint) {
        
        for node in greens.children {
            let distance = distanceTest(point, node.position)
            if distance <= 60 {
                addPoof("GreenPoof", position: node.position, duration: 1.2)
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
                addPoof("RedPoof", position: node.position, duration: 0.8)
                node.removeFromParent()
                if !muteSFX {run(SKAction.playSoundFileNamed("blast.mp3", waitForCompletion: false))}
            }
        }
        
        for node in blues.children {
            let distance = distanceTest(point, node.position)
            if distance <= 60 {
                addPoof("BluePoof", position: node.position, duration: 0.8)
                node.removeFromParent()
                if !muteSFX {run(SKAction.playSoundFileNamed("blast.mp3", waitForCompletion: false))}
            }
        }
        
        for node in yellows.children {
            let distance = distanceTest(point, node.position)
            if distance <= 60 {
                addPoof("YellowPoof", position: node.position, duration: 0.8)
                node.removeFromParent()
                GameOver(.yellow)
            }
        }
        
        buttonDownTest(point, node: menuOnButton, range: 32)
        if buttonUpTest(point, node: menuOnButton, range: 32) {
            turnMenuOn(self)
        }
        
        tap.position = point
        tap.run(.fadeOut(withDuration: 0.25), completion: {self.tap.position = CGPoint(x: -100, y: -100); self.tap.alpha = 1})
    }
    
    func inputBegan(_ point: CGPoint) {
        if !menuOn {
            directInput(point)
        } else {
            menuInputBegan(self, point: point)
        }
    }
    
    func inputEnded(_ point: CGPoint) {
        if menuOn {
            menuInputEnded(self, point: point)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if menuOn {
            for child in children {
                if !(child === menubg) {
                    child.isPaused = true
                }
            }
        } else {
            if score > Int(oldFrameScore)! + 2 {
                fatalError("Fuck you cheater! ")
            }
            
            if Int(currentTime * 10) >= Int(oldTime + 1) {
                timeElapsed += 0.1
            }
            
            if timeElapsed >= lastSpawnBallTime + 1 {
                spawnBall()
                lastSpawnBallTime = timeElapsed
            }
            
            if record < score {
                record = score
                standardDefaults.set(score, forKey: "record\(mode)")
                standardDefaults.synchronize()
            }
            
            if mute {
                bgm.volume = 0
            } else {
                bgm.volume = 1
            }
            
            if !bgm.isPlaying {
                bgm.play()
            }
            
            scoreLabel.text = String(score)
            oldTime = Int(currentTime * 10)
            oldFrameScore = "\(score)"
            recordLabel.text = NSLocalizedString("RecordText", comment: "Record: ") + "\(record)"
        }
    }
}

#if os(iOS)
    
    extension GamePlayScene {
        
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
    
#endif

#if os(OSX)
    
    extension GamePlayScene {
        
        override func mouseDown(with theEvent: NSEvent) {
            inputBegan(theEvent.location(in: self))
        }
        
        override func mouseUp(with theEvent: NSEvent) {
            inputEnded(theEvent.location(in: self))
        }
        
        override func keyDown(with theEvent: NSEvent) {
            if !menuOn && theEvent.keyCode == keyCodeEsc {
                turnMenuOn(self)
            }
        }
        
    }
    
#endif
