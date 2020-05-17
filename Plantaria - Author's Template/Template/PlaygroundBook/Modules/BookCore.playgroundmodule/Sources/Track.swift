//
//  Track.swift
//  Plant
//
//  Created by Enzo Maruffa Moreira on 15/05/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import AVFoundation

class Track: NSObject {
    private var player: AVAudioPlayer!
    
    func load(_ fileName: String, _ volume: Float) -> AVAudioPlayer {
        let path = Bundle.main.path(forResource: fileName, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.volume = volume
            player.prepareToPlay()
            player.numberOfLoops = -1 // infinite loop
            return player
        } catch {
            fatalError("Error loading track")
        }
    }
    
    init(fileName: String, volume: Float) {
        super.init()
        self.player = load(fileName, volume)
    }
    
    convenience init(fileName: String) {
        self.init(fileName: fileName, volume: 1.0)
    }
    
    func play() {
        if player.isPlaying {
            return
        }
        
        player.play()
    }
    
    func stop() {
        player.stop()
    }
}
