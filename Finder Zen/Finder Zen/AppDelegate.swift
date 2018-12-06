//
//  AppDelegate.swift
//  Finder Zen
//
//  Created by Vince14Genius on 8/28/15.
//  Copyright (c) 2015 Vince14Genius. All rights reserved.
//


import Cocoa
import SpriteKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var skView: SKView!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        /* Pick a size for the scene */
        if let scene = GameScene(fileNamed:"GameScene") {
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFit
            
            self.skView!.presentScene(scene)
            
            self.skView!.ignoresSiblingOrder = true
            
            self.skView!.showsFPS = true
        }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    func gamePause() {
        if skView.scene!.isKind(of: GamePlayScene.self) {
            menubg.removeAllActions()
            menubg.alpha = 1
            turnMenuOn(skView.scene!)
        } else {
            skView.isPaused = true
            bgm.pause()
        }
    }
    
    func applicationDidResignActive(_ notification: Notification) {
        gamePause()
    }
    
    func applicationDidHide(_ notification: Notification) {
        gamePause()
    }
    
    func applicationDidBecomeActive(_ notification: Notification) {
        if !(skView.scene?.isKind(of: GamePlayScene.self) ?? false) {
            skView.isPaused = false
            bgm.play()
        }
    }
}
