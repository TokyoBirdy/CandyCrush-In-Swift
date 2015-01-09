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
    var moveLeft = 0
    var score = 0
    
    @IBOutlet var lblTarget: UILabel!
    @IBOutlet var lblMoves: UILabel!
    @IBOutlet var lblScore: UILabel!
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
        moveLeft = level.maximumMoves
        score = 0
        updateLabels()
        level.resetComboMultiplier()
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
            scene.animateSwap(swap,completion:handleMatches)
        } else {
            scene.animateInvalidSwap(swap, completion:{
                self.view.userInteractionEnabled = true
            })
            
        }
    }
    
    
    func handleMatches(){
        let chains = level.removeMatches()
        if chains.count == 0 {
            level.resetComboMultiplier()
            beginNextTurn()
            return
        }
        
        scene.animateMatchedCookies(chains){
            for chain in chains{
                self.score += chain.score
            }
            self.updateLabels()
            
            let columns = self.level.fillHoles()
            self.scene.animateFallingCookies(columns, completion: {
                let columns = self.level.topUpCookies()
                self.scene.animateNewCookies(columns, completion: {
                    self.handleMatches()
                })
            })
           
        }
    }
    
    func beginNextTurn() {
        level.detectPossibleSwaps()
        view.userInteractionEnabled = true
    }
    
    
    func updateLabels(){
        lblTarget.text = NSString(format: "%ld", level.targetScore)
        lblMoves.text = NSString(format: "%ld", moveLeft)
        lblScore.text = NSString(format: "%ld", score)
    }
    
  
    
    
}
