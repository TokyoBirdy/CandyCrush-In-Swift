//
//  GameViewController.swift
//  CookieCrunch
//
//  Created by Cecilia Humlelu on 26/11/14.
//  Copyright (c) 2014 HU. All rights reserved.
//

import UIKit
import SpriteKit



class GameViewController: UIViewController {
    
    var scene:GameScene!
    var level:Level!
    
    override func prefersStatusBarHidden()->Bool {
        return true
    }
    override func shouldAutorotate()->Bool{
        return true
    }
    
    override func supportedInterfaceOrientations()->Int {
        return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let skView = view as SKView
        skView.multipleTouchEnabled = false
        
        level = Level(filename: "Level_1")
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFit
        scene.level = level
        scene.addTiles()
        scene.swipeHandler = handleSwipe
        skView.presentScene(scene)
        beginGame()
    }
    
    
    func beginGame(){
        shuffle()
    }
    
    
    func shuffle(){
        let newCookies = level.shuffle()
        scene.addSpritesForCookies(newCookies)
    }
    
    func handleSwipe(swap:Swap){
        view.userInteractionEnabled = false
        
        if level.isPossibleSwap(swap){
            level.performSwap(swap)
            scene.animateSwap(swap,completion:{
                self.view.userInteractionEnabled = true
            })
        } else {
            scene.animateInvalidSwap(swap, completion:{
                self.view.userInteractionEnabled = true
            })
            
        }
    }
    
    
    
}
