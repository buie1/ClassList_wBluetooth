//
//  muiscPlayer.swift
//  cts20-ECE590-hw4
//
//  Created by Colby Stanley on 9/26/16.
//  Copyright © 2016 Colby Stanley. All rights reserved.
//  found at http://stackoverflow.com/questions/31422014/play-background-music-in-app

import Foundation

import AVFoundation

class MusicPlayer {
    static let sharedHelper = MusicPlayer()
    var audioPlayer: AVAudioPlayer?
    
    func playBackgroundMusic() {
        let aSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("song", ofType: "mp3")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL:aSound)
            audioPlayer!.numberOfLoops = -1
            audioPlayer!.prepareToPlay()
            audioPlayer!.play()
        } catch {
            print("Cannot play the file")
        }
    }
    func stop(){
        if(audioPlayer != nil){
            if(audioPlayer!.playing){
                audioPlayer!.stop()
            }
        }
    }
}