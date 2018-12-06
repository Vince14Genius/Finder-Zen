//
//  GameScene.swift
//  Finder Zen
//
//  Created by Vince14Genius on 8/28/15.
//  Copyright (c) 2015 Vince14Genius. All rights reserved.
//

import SpriteKit
import AVFoundation

public enum GameMode {
    case casual, normal, deadly
}

public enum DeathCause {
    case red, yellow
}

public enum ConfirmingAction {
    case reset, toggleColorblindMode
}

public let deathRed = #colorLiteral(red: 0.2, green: 0, blue: 0, alpha: 1)
public let deathYellow = #colorLiteral(red: 0.2, green: 0.2, blue: 0, alpha: 1)
public let standardDefaults = UserDefaults.standard

public var mute = false
public var muteSFX = false
public var colorblindMode = false
public var bgm = AVAudioPlayer()

public var menuOn = false

public var clickedButton = SKSpriteNode()

//Compares the distance between two points (using the pythagorean theorem)

func distanceTest(_ p1: CGPoint, _ p2: CGPoint) -> CGFloat {
    let xDiff = p1.x - p2.x
    let yDiff = p1.y - p2.y
    let distance = sqrtf(Float(xDiff * xDiff + yDiff * yDiff))
    return CGFloat(distance)
}

//Sets up a label with an x value of 0

func labelSetup(_ text: String, parent: SKNode, size: CGFloat, y: CGFloat) {
    let node = SKLabelNode(text: text)
    node.fontName = NSFont.systemFont(ofSize: 114514).fontName
    node.fontSize = size
    node.position.y = y
    node.zPosition = 3
    parent.addChild(node)
}

//Sets up a regular button with a given image and a given position

func buttonSetup(_ node: SKSpriteNode, scene: SKScene, sideLength: CGFloat, x: CGFloat, y: CGFloat) {
    node.size = CGSize(width: sideLength, height: sideLength)
    node.position = CGPoint(x: x, y: y)
    node.zPosition = 2
    scene.addChild(node)
}

//Three functions that tests if a button is being pressed

func buttonHoverTest(_ point: CGPoint, node: SKSpriteNode, range: CGFloat) {
    let distance = distanceTest(point, node.position)
    if distance <= range {
        if node.xScale != 1.2 {
            node.run(.scale(to: 1.1, duration: 0.1))
        }
    } else {
        node.run(.scale(to: 1.0, duration: 0.1))
    }
}

func buttonDownTest(_ point: CGPoint, node: SKSpriteNode, range: CGFloat) {
    let distance = distanceTest(point, node.position)
    if distance <= range {
        clickedButton = node
        node.run(.scale(to: 1.2, duration: 0.1))
    }
}

func buttonUpTest(_ point: CGPoint, node: SKSpriteNode, range: CGFloat) -> Bool {
    node.run(.scale(to: 1.0, duration: 0.1))
    if clickedButton === node {
        let distance = distanceTest(point, node.position)
        if distance <= range {
            return true
        }
    }
    return false
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//The initial scene, automatically goes to the title scene.
class GameScene: SKScene {
    override func didMove(to view: SKView) {
        menuInit()
        view.presentScene(GameTitleScene(size: CGSize(width: 1024, height: 768)))
    }
}

//The title scene, providing buttons to each game mode.
class GameTitleScene: SKScene {
    
    let Background = SKSpriteNode(imageNamed: "Background")
    let Title = SKSpriteNode(imageNamed: "Title")
    
    let casualButton = SKSpriteNode(imageNamed: "BubbleGreen")
    let normalButton = SKSpriteNode(imageNamed: "BubbleBlue")
    let deadlyButton = SKSpriteNode(imageNamed: "BubbleRed")
    
    let muteButton = SKSpriteNode(imageNamed: "BubbleCyan2")
    let muteSFXButton = SKSpriteNode(imageNamed: "BubbleCyan")
    let resetButton = SKSpriteNode(imageNamed: "BubblePurple")
    let colorblindButton = SKSpriteNode(imageNamed: "BubblePurple2")
    
    let bubbles = SKNode()

    func buttonClicked(_ mode: GameMode) {
        view!.presentScene(GamePlayScene(size: CGSize(width: 800, height: 600), mode: mode), transition: .fade(withDuration: 1.0))
    }
    
    override init(size: CGSize) {
        clickedButton = Title
        
        super.init(size: size)
        backgroundColor = .black
        scaleMode = .aspectFit
        
        Background.position = CGPoint(x: 512, y: 384)
        Background.alpha = 0.75
        Background.zPosition = 1
        addChild(Background)
        
        buttonSetup(casualButton, scene: scene!, sideLength: 160, x: 320, y: 300)
        buttonSetup(normalButton, scene: scene!, sideLength: 160, x: 512, y: 300)
        buttonSetup(deadlyButton, scene: scene!, sideLength: 160, x: 704, y: 300)
        
        buttonSetup(muteButton, scene: scene!, sideLength: 80, x: 224, y: 150)
        buttonSetup(muteSFXButton, scene: scene!, sideLength: 80, x: 416, y: 150)
        buttonSetup(resetButton, scene: scene!, sideLength: 80, x: 608, y: 150)
        buttonSetup(colorblindButton, scene: scene!, sideLength: 80, x: 800, y: 150)
        
        labelSetup(NSLocalizedString("Casual", comment: "Casual"), parent: casualButton, size: 32, y: 8)
        labelSetup(NSLocalizedString("Normal", comment: "Normal"), parent: normalButton, size: 32, y: 8)
        labelSetup(NSLocalizedString("Deadly", comment: "Deadly"), parent: deadlyButton, size: 32, y: 8)
        
        bubbles.zPosition = 1.5
        bubbles.position = CGPoint(x: 512, y: 384)
        addChild(bubbles)
        
        Title.position = CGPoint(x: 512, y: 384)
        Title.zPosition = 4
        addChild(Title)
        
        let casualKey = "record\(GameMode.casual)"
        let normalKey = "record\(GameMode.normal)"
        let deadlyKey = "record\(GameMode.deadly)"
        
        let ambientBlue = SKEmitterNode(fileNamed: "TitleBlue.sks")!
        let ambientRed = SKEmitterNode(fileNamed: "TitleRed.sks")!
        let ambientYellow = SKEmitterNode(fileNamed: "TitleYellow.sks")!
        let ambientGreen = SKEmitterNode(fileNamed: "TitleGreen.sks")!
        
        bubbles.addChild(ambientBlue)
        bubbles.addChild(ambientRed)
        bubbles.addChild(ambientYellow)
        bubbles.addChild(ambientGreen)
        
        let recordText = NSLocalizedString("RecordText", comment: "Record: ")
        
        labelSetup("\(recordText)\(standardDefaults.integer(forKey: casualKey))", parent: casualButton, size: 18, y: -40)
        labelSetup("\(recordText)\(standardDefaults.integer(forKey: normalKey))", parent: normalButton, size: 18, y: -40)
        labelSetup("\(recordText)\(standardDefaults.integer(forKey: deadlyKey))", parent: deadlyButton, size: 18, y: -40)
        labelSetup("X", parent: muteButton, size: 80, y: -28)
        labelSetup("X", parent: muteSFXButton, size: 80, y: -28)
        labelSetup("X", parent: colorblindButton, size: 80, y: -28)
        
        mute = standardDefaults.bool(forKey: "mute")
        muteButton.children[0].isHidden = !mute
        
        muteSFX = standardDefaults.bool(forKey: "muteSFX")
        muteSFXButton.children[0].isHidden = !muteSFX
        
        colorblindMode = standardDefaults.bool(forKey: "colorblindMode")
        colorblindButton.children[0].isHidden = colorblindMode
        
        labelSetup(NSLocalizedString("StartDev", comment: "Visit StartDev.org for more. "), parent: Title, size: 24, y: -376)
        
        do {
            try bgm = AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "title", withExtension: "mp3")!)
        } catch {
            fatalError("Failed to init AVAudioPlayer. ")
        }
        
        if !standardDefaults.bool(forKey: "completedTutorial") {
            run(.wait(forDuration: 0.01), completion: {
                 self.view!.presentScene(TutorialTransfer(size: size, stage: 1), transition: .fade(withDuration: 1.0))
            })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func inputHover(_ point: CGPoint) {
        buttonHoverTest(point, node: casualButton, range: 90)
        buttonHoverTest(point, node: normalButton, range: 90)
        buttonHoverTest(point, node: deadlyButton, range: 90)
        buttonHoverTest(point, node: muteButton, range: 45)
        buttonHoverTest(point, node: muteSFXButton, range: 45)
        buttonHoverTest(point, node: resetButton, range: 45)
        buttonHoverTest(point, node: colorblindButton, range: 45)
    }
    
    func inputBegan(_ point: CGPoint) {
        buttonDownTest(point, node: casualButton, range: 90)
        buttonDownTest(point, node: normalButton, range: 90)
        buttonDownTest(point, node: deadlyButton, range: 90)
        buttonDownTest(point, node: muteButton, range: 45)
        buttonDownTest(point, node: muteSFXButton, range: 45)
        buttonDownTest(point, node: resetButton, range: 45)
        buttonDownTest(point, node: colorblindButton, range: 45)
        if point.x >= 256 && point.x <= 768 && point.y >= 420 && point.y <= 640 {
            clickedButton = Title
            Title.run(.scale(to: 1.1, duration: 0.2))
        }
    }
    
    func inputEnded(_ point: CGPoint) {
        if buttonUpTest(point, node: casualButton, range: 90) {
            buttonClicked(.casual)
        }
        if buttonUpTest(point, node: normalButton, range: 90) {
            buttonClicked(.normal)
        }
        if buttonUpTest(point, node: deadlyButton, range: 90) {
            buttonClicked(.deadly)
        }
        if buttonUpTest(point, node: muteButton, range: 45) {
            mute = !mute
            muteButton.children[0].isHidden = !mute
            standardDefaults.set(mute, forKey: "mute")
            standardDefaults.synchronize()
        }
        if buttonUpTest(point, node: muteSFXButton, range: 45) {
            muteSFX = !muteSFX
            muteSFXButton.children[0].isHidden = !muteSFX
            standardDefaults.set(muteSFX, forKey: "muteSFX")
            standardDefaults.synchronize()
        }
        if buttonUpTest(point, node: resetButton, range: 45) {
            view!.presentScene(GameConfirmScene(size: size, action: .reset), transition: .moveIn(with: .down, duration: 0.5))
        }
        if buttonUpTest(point, node: colorblindButton, range: 45) {
            view!.presentScene(GameConfirmScene(size: size, action: .toggleColorblindMode), transition: .moveIn(with: .down, duration: 0.5))
        }
        if point.x >= 256 && point.x <= 768 && point.y >= 420 && point.y <= 640 && clickedButton === Title {
            view!.presentScene(TutorialTransfer(size: size, stage: 1), transition: .fade(withDuration: 1.0))
        }
        Title.run(.scale(to: 1.0, duration: 0.2))
        clickedButton = Background
    }
    
    override func update(_ currentTime: TimeInterval) {
        if !bgm.isPlaying {
            bgm.play()
        }
        
        if mute {
            bgm.volume = 0
        } else {
            bgm.volume = 1
        }
    }
}

//The game-over scene, displaying final scores and stuff.
class GameOverScene: SKScene {
    func setlabel(_ text: String, fontSize: CGFloat, y: CGFloat) {
        let node = SKLabelNode(text: text)
        node.fontName = NSFont.systemFont(ofSize: 114514).fontName
        node.fontSize = fontSize
        node.position = CGPoint(x: 512, y: y)
        node.zPosition = 2
        addChild(node)
    }
    
    init(size: CGSize, score: Int, mode: GameMode, deathCause: DeathCause) {
        let record = standardDefaults.integer(forKey: "record\(mode)")
        
        super.init(size: size)
        scaleMode = .aspectFit
        
        let modeText: String
        switch mode {
        case .casual: modeText = NSLocalizedString("Casual", comment: "Casual")
        case .normal: modeText = NSLocalizedString("Normal", comment: "Normal")
        case .deadly: modeText = NSLocalizedString("Deadly", comment: "Deadly")
        }
        
        setlabel(NSLocalizedString("GameMode", comment: "Game Mode: ") + "\(modeText)", fontSize: 48, y: 500)
        setlabel(NSLocalizedString("FinalScore", comment: "Final Score: ") + "\(score)", fontSize: 72, y: 350)
        setlabel(NSLocalizedString("YourRecord", comment: "Your Record: ") + "\(record)", fontSize: 48, y: 225)
        
        let Background = SKSpriteNode(imageNamed: "Background")
        Background.position = CGPoint(x: 512, y: 384)
        Background.alpha = 0.25
        Background.zPosition = 1
        addChild(Background)
        
        if deathCause == .red {
            backgroundColor = deathRed
        } else if deathCause == .yellow {
            backgroundColor = deathYellow
        }
        
        if !muteSFX {run(.playSoundFileNamed("lose.mp3", waitForCompletion: false))}
        run(.run({bgm.volume = 0}))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func inputEnded(_ point: CGPoint) {
        view!.presentScene(GameTitleScene(size: CGSize(width: 1024, height: 768)), transition: .fade(withDuration: 1.0))
    }
}


//The confirm scene, letting the user confirm actions.
class GameConfirmScene: SKScene {
    let confirmButton = SKSpriteNode(imageNamed: "BubbleRed")
    let cancelButton = SKSpriteNode(imageNamed: "BubbleBlue")
    let Background = SKSpriteNode(imageNamed: "Background")
    let action: ConfirmingAction
    
    init(size: CGSize, action: ConfirmingAction) {
        self.action = action
        super.init(size: size)
        scaleMode = .aspectFit
        backgroundColor = .black
        
        Background.position = CGPoint(x: 512, y: 384)
        Background.alpha = 0.75
        Background.zPosition = 1
        addChild(Background)
        
        buttonSetup(confirmButton, scene: scene!, sideLength: 160, x: 384, y: 200)
        buttonSetup(cancelButton, scene: scene!, sideLength: 160, x: 640, y: 200)
        labelSetup(NSLocalizedString("ConfirmReset1", comment: "Are you sure you want to"), parent: Background, size: 48, y: 128)
        
        switch action {
        case .reset:
            labelSetup(NSLocalizedString("ConfirmReset2", comment: "reset all records to 0?"), parent: Background, size: 56, y: 64)
            labelSetup(NSLocalizedString("Reset", comment: "Reset"), parent: confirmButton, size: 36, y: -8)
            labelSetup(NSLocalizedString("Cancel", comment: "Cancel"), parent: cancelButton, size: 36, y: -8)
        case .toggleColorblindMode:
            if colorblindMode {
                labelSetup(NSLocalizedString("CBTurnOff", comment: "turn off colorblind mode?"), parent: Background, size: 56, y: 64)
            } else {
                labelSetup(NSLocalizedString("CBTurnOn", comment: "turn on colorblind mode?"), parent: Background, size: 56, y: 64)
            }
            labelSetup(NSLocalizedString("Yes", comment: "Yes"), parent: confirmButton, size: 36, y: -8)
            labelSetup(NSLocalizedString("No", comment: "No"), parent: cancelButton, size: 36, y: -8)
        }
        
        run(.run({bgm.volume = 0}))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func inputBegan(_ point: CGPoint) {
        buttonDownTest(point, node: confirmButton, range: 90)
        buttonDownTest(point, node: cancelButton, range: 90)
    }
    
    func inputEnded(_ point: CGPoint) {
        if buttonUpTest(point, node: confirmButton, range: 90) {
            switch action {
            case .reset:
                standardDefaults.set(0, forKey: "record\(GameMode.casual)")
                standardDefaults.set(0, forKey: "record\(GameMode.normal)")
                standardDefaults.set(0, forKey: "record\(GameMode.deadly)")
                standardDefaults.synchronize()
                view!.presentScene(GameTitleScene(size: size), transition: .fade(withDuration: 1.0))
            case .toggleColorblindMode:
                colorblindMode = !colorblindMode
                standardDefaults.set(colorblindMode, forKey: "colorblindMode")
                standardDefaults.synchronize()
                view!.presentScene(GameTitleScene(size: size), transition: .fade(withDuration: 0.5))
            }
        }
        if buttonUpTest(point, node: cancelButton, range: 90) {
            view!.presentScene(GameTitleScene(size: size), transition: .reveal(with: .down, duration: 0.5))
        }
        clickedButton = Background
    }

}

#if os(iOS)
    extension GameTitleScene {
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
    
    extension GameOverScene {
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            if let touch = touches.first {
                inputEnded(touch.location(in: self))
            }
        }
    }
    
    extension GameConfirmScene {
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
    extension GameTitleScene {
        override func mouseMoved(with theEvent: NSEvent) { //For some reason, mouseMoved does not work...
            inputHover(theEvent.location(in: self))
        }
        
        override func mouseDown(with theEvent: NSEvent) {
            inputBegan(theEvent.location(in: self))
        }
        
        override func mouseUp(with theEvent: NSEvent) {
            inputEnded(theEvent.location(in: self))
        }
    }
    
    extension GameOverScene {
        override func mouseUp(with theEvent: NSEvent) {
            inputEnded(theEvent.location(in: self))
        }
    }
    
    extension GameConfirmScene {
        override func mouseDown(with theEvent: NSEvent) {
            inputBegan(theEvent.location(in: self))
        }
        
        override func mouseUp(with theEvent: NSEvent) {
            inputEnded(theEvent.location(in: self))
        }
    }
#endif
