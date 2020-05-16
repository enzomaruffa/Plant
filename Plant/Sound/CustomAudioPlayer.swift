//
//  CustomAudioPlayer.swift
//  Plant
//
//  Created by Enzo Maruffa Moreira on 15/05/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import AVFoundation

class CustomAudioPlayer {
    private var players = [AVAudioPlayer]()
    private var url: URL!
    
    var volume: Float = 1.0
    
    fileprivate func load() {
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.volume = volume
            player.prepareToPlay()
            players.append(player)
        } catch {
            print("Error loading sound")
        }
    }
    
    init(fileName: String, volume: Float) {
        guard let path = Bundle.main.path(forResource: fileName, ofType:nil) else {
            print("Error loading file \(fileName)")
            exit(5)
        }
        url = URL(fileURLWithPath: path)
        self.volume = volume
        load()
    }
    
    convenience init(fileName: String) {
        self.init(fileName: fileName, volume: 1.0)
    }
    
    func play() {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let player = self.players.filter({ !$0.isPlaying }).first else {
                self.load()
                self.players.last?.play()
                return
            }
            
            player.play()
        }
    }
    
    func stopAll() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.players.forEach({
                $0.stop()
            })
        }
    }
    
}
