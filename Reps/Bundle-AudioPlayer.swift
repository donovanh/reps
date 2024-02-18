//
//  Bundle-AudioPlayer.swift
//  Reps
//
//  Created by Donovan Hutchinson on 18/02/2024.
//

import AVFoundation

extension Bundle {
    func audioPlayer(for filename: String, volume: Double = 1.0) -> AVAudioPlayer {
        guard let audioURL = url(forResource: filename, withExtension: nil) else {
            fatalError("No file \(filename)")
        }
        
        guard let player = try? AVAudioPlayer(contentsOf: audioURL) else {
            fatalError("Failed to load \(filename)")
        }
        
        player.volume = Float(volume)
        player.prepareToPlay()
        
        return player
    }
}
