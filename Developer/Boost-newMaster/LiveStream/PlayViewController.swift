//
//  playViewController.swift
//  LiveStream
//
//  Created by Alexander Lindsay on 5/9/17.
//  Copyright © 2017 com.continuum. All rights reserved.
//

import UIKit


class PlayViewController: UIViewController, BambuserPlayerDelegate {
    var bambuserPlayer : BambuserPlayer
    var playButton: UIButton
    var pauseButton: UIButton
    var rewindButton: UIButton
    
    required init?(coder aDecoder: NSCoder) {
        bambuserPlayer = BambuserPlayer()
        playButton = UIButton(type: UIButtonType.system)
        pauseButton = UIButton(type: UIButtonType.system)
        rewindButton = UIButton(type: UIButtonType.system)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Need to make frame for the player and put it somewhere
        let playerFrame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height * 0.8)
        bambuserPlayer.frame = playerFrame
        
        bambuserPlayer.delegate = self
        bambuserPlayer.applicationId = "Do14yFBjvRaFc8ut0Ri6LA"
        bambuserPlayer.playVideo("https://cdn.bambuser.net/broadcasts/ec968ec1-2fd9-f8f3-4f0a-d8e19dccd739?da_signature_method=HMAC-SHA256&da_id=432cebc3-4fde-5cbb-e82f-88b013140ebe&da_timestamp=1456740399&da_static=1&da_ttl=0&da_signature=8e0f9b98397c53e58f9d06d362e1de3cb6b69494e5d0e441307dfc9f854a2479")
        self.view.addSubview(bambuserPlayer)
        playButton.setTitle("Play", for: UIControlState.normal)
        playButton.addTarget(bambuserPlayer, action: #selector(BambuserPlayer.playVideo as (BambuserPlayer) -> () -> Void), for: UIControlEvents.touchUpInside)
        self.view.addSubview(playButton)
        pauseButton.setTitle("Pause", for: UIControlState.normal)
        pauseButton.addTarget(bambuserPlayer, action: #selector(BambuserPlayer.pauseVideo as (BambuserPlayer) -> () -> Void), for: UIControlEvents.touchUpInside)
        self.view.addSubview(pauseButton)
        rewindButton.setTitle("Rewind", for: UIControlState.normal)
        //rewindButton.addTarget(self, action: #selector(ViewController.rewind), for: UIControlEvents.touchUpInside)
        self.view.addSubview(rewindButton)
    }
    
    func playbackStarted() {
        playButton.isEnabled = false
        pauseButton.isEnabled = true
    }
    
    func playbackPaused() {
        playButton.isEnabled = true
        pauseButton.isEnabled = false
    }
    
    func playbackStopped() {
        playButton.isEnabled = true
        pauseButton.isEnabled = false
    }
    
    func videoLoadFail() {
        NSLog("Failed to load video for %@", bambuserPlayer.resourceUri);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
