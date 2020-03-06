//
//  MenuScene.swift
//  StarShip
//
//  Created by Graphic Influence on 06/03/2020.
//  Copyright © 2020 marianne massé. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {

    var sceneManagerDelegate: SceneManagerDelegate?
    
    var starField: SKEmitterNode!
    var menuLabel: SKLabelNode!

    override func didMove(to view: SKView) {
        setupMenu()
    }

    func setupMenu() {
        backgroundColor = .black
        starField = SKEmitterNode(fileNamed: "starfield")!
        starField.position = CGPoint(x: 1024, y: 384)
        starField.zPosition = -1
        addChild(starField)

        menuLabel = SKLabelNode(fontNamed: "Chalkduster")
        menuLabel.text = "StarShip"
        menuLabel.aspectScale(to: frame.size, width: true, multiplier: 0.5)
        menuLabel.position = CGPoint(x: frame.midX, y: frame.midY * 1.6)
        addChild(menuLabel)

        let button = SpriteKitButton(defaultButtonImage: "play", action: gamePlay, index: 0)
        button.position = CGPoint(x: frame.midX, y: frame.midY)
        button.zPosition = 1
        button.aspectScale(to: frame.size, width: false, multiplier: 0.2)

        addChild(button)


        let highScore = SKLabelNode(text: "Highscore: " + "\(UserDefaults.standard.integer(forKey: "Highscore"))")
        highScore.position = CGPoint(x: frame.midX, y: frame.midY / 2)
        highScore.aspectScale(to: frame.size, width: false, multiplier: 0.1)
        addChild(highScore)

        let recentScore = SKLabelNode(text: "Recentscore: " + "\(UserDefaults.standard.integer(forKey: "RecentScore"))")
        recentScore.position = CGPoint(x: frame.midX, y: frame.midY / 4)
        recentScore.aspectScale(to: frame.size, width: false, multiplier: 0.1)
        addChild(recentScore)

        animationAlpha(button: button, label: highScore)

    }

    func gamePlay(_: Int) {
        sceneManagerDelegate?.presentGameScene()
    }

    func animationAlpha(button: SpriteKitButton?, label: SKLabelNode?) {
        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)

        let scaleUp = SKAction.scale(to: 1.2, duration: 0.5)
        let scaleDown = SKAction.scale(to: 1, duration: 0.5)

        let sequence1 = SKAction.sequence([fadeIn, fadeOut])
        button?.run(SKAction.repeatForever(sequence1))

        let highscore = UserDefaults.standard.integer(forKey: "Highscore")
        let recentScore = UserDefaults.standard.integer(forKey: "RecentScore")
        let sequence2 = SKAction.sequence([scaleUp, scaleDown])

        if highscore == recentScore {
        label?.run(SKAction.repeatForever(sequence2))
        }
    }

}
