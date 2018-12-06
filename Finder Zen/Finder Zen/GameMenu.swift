//
//  GameMenu.swift
//  Finder Zen
//
//  Created by Vince14Genius on 4/12/16.
//  Copyright © 2016 Vince14Genius. All rights reserved.
//

import SpriteKit

let menubg = SKSpriteNode(imageNamed: "pausedbg")
let menuText = SKLabelNode(text: NSLocalizedString("GamePaused", comment: "Game Paused"))

let menuButton = SKSpriteNode(imageNamed: "BubblePurple4")
let menuHomeButton = SKSpriteNode(imageNamed: "BubbleCyan3")
let menuMuteButton = SKSpriteNode(imageNamed: "BubbleCyan")
let menuMuteMusicButton = SKSpriteNode(imageNamed: "BubbleCyan2")
let menuCBButton = SKSpriteNode(imageNamed: "BubblePurple2")

//Two setup functions that sets up the nodes in the pause menu.

func menuLabelSetup(_ text: String, parent: SKNode) {
    let node = SKLabelNode(text: text)
    node.fontName = NSFont.systemFont(ofSize: 114514).fontName
    node.fontSize = 24
    node.verticalAlignmentMode = .center
    node.horizontalAlignmentMode = .left
    node.position.x = 64
    parent.addChild(node)
}

func menuButtonsSetup(_ buttons: [SKSpriteNode]) {
    var y: CGFloat = 64
    for button in buttons {
        button.zPosition = 1
        button.position = CGPoint(x: 64, y: y)
        menubg.addChild(button)
        y += 96
    }
}

//An init function to build the menu when the game launches.

func menuInit() {
    menubg.size = CGSize(width: 1600, height: 1200)
    menubg.zPosition = 20
    menubg.alpha = 0
    menuText.fontName = NSFont.systemFont(ofSize: 114514).fontName
    menuText.fontSize = 36
    menuText.position = CGPoint(x: 400, y: 584)
    menuText.verticalAlignmentMode = .top
    menuText.zPosition = 1
    menubg.addChild(menuText)
    
    menuButtonsSetup([menuButton, menuCBButton, menuMuteMusicButton, menuMuteButton, menuHomeButton])
    
    menuLabelSetup(NSLocalizedString("ReturnToGame", comment: "Return to Game"), parent: menuButton)
    menuLabelSetup(NSLocalizedString("MainMenu", comment: "Main Menu"), parent: menuHomeButton)
    menuLabelSetup(NSLocalizedString("MuteSFX", comment: "Mute Sound Effects"), parent: menuMuteButton)
    menuLabelSetup(NSLocalizedString("MuteMusic", comment: "Mute Music"), parent: menuMuteMusicButton)
    menuLabelSetup(NSLocalizedString("CBMode", comment: "Colorblind-Friendly Mode"), parent: menuCBButton)
    
    labelSetup("X", parent: menuMuteButton, size: 80, y: -28)
    labelSetup("X", parent: menuMuteMusicButton, size: 80, y: -28)
    labelSetup("X", parent: menuCBButton, size: 80, y: -28)
    
    menuMuteMusicButton.children[1].isHidden = !mute
    menuMuteButton.children[1].isHidden = !muteSFX
    menuCBButton.children[1].isHidden = colorblindMode
}

//Three functions for showing and hiding the pause menu.

func turnMenuOn(_ scene: SKScene) {
    menuOn = true
    bgm.pause()
    for child in scene.children {
        if !(child === menubg) {
            child.isPaused = true
        }
    }
    menuMuteMusicButton.children[1].isHidden = !mute
    menuMuteButton.children[1].isHidden = !muteSFX
    menuCBButton.children[1].isHidden = colorblindMode
    if let _ = menubg.parent {
        menubg.removeFromParent()
    }
    scene.addChild(menubg)
    menubg.run(.fadeIn(withDuration: 0.25))
}

func turnMenuOff(_ scene: SKScene) {
    bgm.play()
    menubg.run(.sequence([.fadeOut(withDuration: 0.75), .run({
        menuOn = false
        for child in scene.children {
            child.isPaused = false
        }
    }), .removeFromParent()]))
}

func turnMenuOffImmediately(_ scene: SKScene) {
    bgm.play()
    menuOn = false
    menubg.alpha = 0
    menubg.removeFromParent()
}

//Two more functions to handle click events in the menu.
//menuInputBegan is equivalent to mouseDown and touchesBegan
//menuInputEnded is equivalent to mouseUp and touchesEnded

func menuInputBegan(_ scene: SKScene, point: CGPoint) {
    buttonDownTest(point, node: menuButton, range: 32)
    buttonDownTest(point, node: menuHomeButton, range: 32)
    buttonDownTest(point, node: menuMuteButton, range: 32)
    buttonDownTest(point, node: menuMuteMusicButton, range: 32)
    buttonDownTest(point, node: menuCBButton, range: 32)
}

func menuInputEnded(_ scene: SKScene, point: CGPoint) {
    if buttonUpTest(point, node: menuButton, range: 32) && menubg.alpha == 1 {
        turnMenuOff(scene)
    }
    
    if buttonUpTest(point, node: menuHomeButton, range: 32) {
        turnMenuOffImmediately(scene)
        scene.run(.playSoundFileNamed("continue.mp3", waitForCompletion: false))
        scene.view!.presentScene(GameTitleScene(size: CGSize(width: 1024, height: 768)), transition: .fade(withDuration: 1.0))
    }
    
    if buttonUpTest(point, node: menuMuteButton, range: 32) {
        muteSFX = !muteSFX
        standardDefaults.set(muteSFX, forKey: "muteSFX")
        standardDefaults.synchronize()
        menuMuteButton.children[1].isHidden = !muteSFX
    }
    
    if buttonUpTest(point, node: menuMuteMusicButton, range: 32) {
        mute = !mute
        standardDefaults.set(mute, forKey: "mute")
        standardDefaults.synchronize()
        menuMuteMusicButton.children[1].isHidden = !mute
    }
    
    if buttonUpTest(point, node: menuCBButton, range: 32) {
        colorblindMode = !colorblindMode
        standardDefaults.set(colorblindMode, forKey: "colorblindMode")
        standardDefaults.synchronize()
        menuCBButton.children[1].isHidden = colorblindMode
    }
}
