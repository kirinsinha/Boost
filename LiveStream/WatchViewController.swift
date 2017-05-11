//
//  WatchViewController.swift
//  LiveStream
//
//  Created by Kirin Sinha Prior on 4/30/17.
//  Copyright © 2017 com.continuum. All rights reserved.
//




import UIKit
import AVKit
import AVFoundation
import Firebase

class WatchViewController: UIViewController, BambuserPlayerDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var boostNumber: UILabel!
    
    @IBOutlet weak var streamLabel: UILabel!
    
    @IBOutlet weak var viewerCount: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var fakeImage: UIImageView!
    @IBOutlet weak var goalNumber: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    
    var index = 0
    
    var challenges = ["Doing a backflip off of the pier!", "Eating 10 hot dogs 🌭🍴💪", "Giving flowers to a stranger 😇💐"]
    
    var people = ["Molly Bootman", "Karen O'Rielly", "John Doe"]
    
    var initBoosts = [16,119,5]
    var avatars = [#imageLiteral(resourceName: "avatar"),#imageLiteral(resourceName: "avatar2"),#imageLiteral(resourceName: "avatar3")]
    var viewers = [563, 66, 228]
    var goalBoosts = [50,300,10]

    
    var arrayLen = 1
    
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
    
    @IBAction func boostAction(_ sender: UIButton) {
        initBoosts[index % arrayLen] += 1
        boostNumber.text = String(initBoosts[index % arrayLen])
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
    
    
    
    func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.up {
            index -= 1
            
            if(index < 0){
                index = index + arrayLen
            }
            
            boostNumber.text = String(initBoosts[index % arrayLen])
            viewerCount.text = String(viewers[index % arrayLen])
            nameLabel.text = people[index % arrayLen]
            streamLabel.text = challenges[index % arrayLen]
            avatarImage.image = avatars[index % arrayLen]
            goalNumber.text = String(goalBoosts[index % arrayLen])

            
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.down {
            index += 1
            boostNumber.text = String(initBoosts[index % arrayLen])
            viewerCount.text = String(viewers[index % arrayLen])
            nameLabel.text = people[index % arrayLen]
            streamLabel.text = challenges[index % arrayLen]
            avatarImage.image = avatars[index % arrayLen]
            goalNumber.text = String(goalBoosts[index % arrayLen])
            

        }
    }
    
    
    
    
    

    
    override func viewDidLoad() {
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        super.viewDidLoad()
        
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 2)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        arrayLen = initBoosts.count
        boostNumber.text = String(initBoosts[index % arrayLen])
        viewerCount.text = String(viewers[index % arrayLen])
        nameLabel.text = people[index % arrayLen]
        streamLabel.text = challenges[index % arrayLen]
        avatarImage.image = avatars[index % arrayLen]
        goalNumber.text = String(goalBoosts[index % arrayLen])
        
        
        let playerFrame = CGRect(x: 0, y: 150, width: self.view.frame.size.width, height: self.view.frame.size.height * 0.5)
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
        
        

        //to interact with side view controlle
        
        
        let menu = UIButton(frame: CGRect(x: 20, y: 35, width: 25, height: 25))
        menu.setImage(#imageLiteral(resourceName: "menu"), for: UIControlState.normal)
        
        menu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addSubview(menu)
        
 
        }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
 


 


