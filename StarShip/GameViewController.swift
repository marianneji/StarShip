//
//  GameViewController.swift
//  StarShip
//
//  Created by Graphic Influence on 06/03/2020.
//  Copyright © 2020 marianne massé. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

protocol SceneManagerDelegate {
    func presentGameScene()
    func presentMenuScene()
}

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        presentMenuScene()
    }
}

extension GameViewController: SceneManagerDelegate {

    func presentGameScene() {
        let sceneName = "GameScene"
        if let gameScene = SKScene(fileNamed: sceneName) as? GameScene {
            gameScene.sceneManagerDelegate = self
            present(scene: gameScene)
        }
    }

    func presentMenuScene() {
        let menuScene = MenuScene()
        menuScene.sceneManagerDelegate = self
        present(scene: menuScene)
    }

    func present(scene: SKScene) {
        if let view = self.view as! SKView? {
            if let gesturRecognizers = view.gestureRecognizers {
                for recognizer in gesturRecognizers {
                    view.removeGestureRecognizer(recognizer)
                }
            }
            scene.scaleMode = .resizeFill
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
        }
    }


}
