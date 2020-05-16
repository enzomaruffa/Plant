//
//  SFXManager.swift
//  Plant
//
//  Created by Enzo Maruffa Moreira on 15/05/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import AVFoundation

class SFXPlayer {
    
    static let shared = SFXPlayer()
    
    private let thud1 = CustomAudioPlayer(fileName: "thud-1.wav", volume: 0.15)
    private let thud2 = CustomAudioPlayer(fileName: "thud-2.wav", volume: 0.15)
    private let thud3 = CustomAudioPlayer(fileName: "thud-3.wav", volume: 0.15)
    private let thud4 = CustomAudioPlayer(fileName: "thud-4.wav", volume: 0.15)
    private let thud5 = CustomAudioPlayer(fileName: "thud-5.wav", volume: 0.15)
    private let thud6 = CustomAudioPlayer(fileName: "thud-6.wav", volume: 0.15)
    
    private let song = Track(fileName: "waltz-of-the-flowers.mp3", volume: 0.05)
    
    func playThud() {
        [thud1, thud2, thud3, thud4, thud5, thud6].randomElement()!.play()
    }
    
    func playSong() {
        song.play()
    }
    
    func stopSong() {
        song.stop()
    }
}

