//
//  GameViewController.swift
//  watchSushi
//
//  Created by Vivek Batra on 2019-10-30.
//  Copyright © 2019 student. All rights reserved.
//

//import Foundation
import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene(size:self.view.bounds.size)
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        
        // property to show hitboxes
        skView.showsPhysics = true
        
        skView.presentScene(scene)
    }
    
    
}
