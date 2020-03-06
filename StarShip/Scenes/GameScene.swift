//
//  GameScene.swift
//  StarShip
//
//  Created by Graphic Influence on 06/03/2020.
//  Copyright © 2020 marianne massé. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    var sceneManagerDelegate: SceneManagerDelegate?


    var starField: SKEmitterNode!
    var player: SKSpriteNode!

    var scoreLabel: SKLabelNode!
    var possibleEnemies = ["ball", "hammer", "tv"]
    var gameTimer: Timer?
    var isGameOver = false

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    override func didMove(to view: SKView) {
        backgroundColor = .black
        starField = SKEmitterNode(fileNamed: "starfield")!
        starField.position = CGPoint(x: 1024, y: 384)
        starField.advanceSimulationTime(10)
        addChild(starField)
        starField.zPosition = -1

        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: frame.size.width/4, y: frame.size.height/2 )
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        player.zPosition = 1
        addChild(player)

        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: frame.size.width/10, y: frame.size.height/8)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.zPosition = 0
        addChild(scoreLabel)

        score = 0

        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self

        gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        }

    @objc fileprivate func createEnemy() {
        guard let enemy = possibleEnemies.randomElement() else { return }

        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
        sprite.aspectScale(to: frame.size, width: false, multiplier: 0.1)
        addChild(sprite)

        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0

    }
        
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered

        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }

        if !isGameOver {
            score += 1
        } else {
            gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(gameOver) , userInfo: nil, repeats: false)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)

        if location.y < 100 {
            location.y = 100
        } else if location.y > 668 {
            location.y = 668
        }

        player.position = location
    }

    func didBegin(_ contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)

        player.removeFromParent()
        isGameOver = true
    }

    @objc func gameOver() {
        UserDefaults.standard.set(score, forKey: "RecentScore")
        if score > UserDefaults.standard.integer(forKey: "Highscore") {
            UserDefaults.standard.set(score, forKey: "Highscore")
        }
        if isGameOver {
            sceneManagerDelegate?.presentMenuScene()
        }
    }
}
