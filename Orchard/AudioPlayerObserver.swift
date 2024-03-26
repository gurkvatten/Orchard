//
//  AudioPlayerObserver.swift
//  Orchard
//
//  Created by Johan Karlsson on 2024-03-26.
//

import Foundation
import AVFoundation

class AudioPlayerObserver: NSObject {
    var player: AVPlayer?
    
    init(player: AVPlayer) {
        self.player = player
        super.init()
        addObservers()
    }
    
    deinit {
        removeObservers()
    }
    
    private func addObservers() {
        player?.addObserver(self, forKeyPath: #keyPath(AVPlayer.currentItem.status), options: [.old, .new], context: nil)
    }
    
    private func removeObservers() {
        player?.removeObserver(self, forKeyPath: #keyPath(AVPlayer.currentItem.status))
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let player = player else { return }
        
        if keyPath == #keyPath(AVPlayer.currentItem.status) {
            if let currentItem = player.currentItem {
                if currentItem.status == .readyToPlay {
                    // AVPlayerItem är redo att spela upp ljudet
                    // Starta uppspelningen här om det behövs ytterligare logik
                    print("AVPlayerItem är redo att spela upp ljudet")
                    player.play()
                } else if currentItem.status == .failed {
                    // Misslyckades med att ladda AVPlayerItem
                    print("Misslyckades med att ladda AVPlayerItem")
                }
            }
        }
    }
}
