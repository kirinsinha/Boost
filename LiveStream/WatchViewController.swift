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

class WatchViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var boostNumber: UILabel!
    
    @IBOutlet weak var streamLabel: UILabel!
    
    @IBOutlet weak var viewerCount: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var fakeImage: UIImageView!
    
    
    var index = 0
    var playVideo = false
    
    var challenges = ["Doing a backflip off of the pier!", "Eating 10 hot dogs 🌭🍴💪", "Giving flowers to a stranger 😇💐"]
    
    var people = ["Molly Bootman", "Karen O'Rielly", "John Doe"]
    
    var initBoosts = [16,119,5]
    var avatars = [#imageLiteral(resourceName: "avatar"),#imageLiteral(resourceName: "avatar2"),#imageLiteral(resourceName: "avatar3")]
    var viewers = [563, 66, 228]
    
    var videoURL = [URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"),URL(string:"http://techslides.com/demos/sample-videos/small.mp4"),URL(string:"http://techslides.com/demos/sample-videos/small.mp4")]
    
    var arrayLen = 1
    
    var player: AVPlayer?
    
    @IBAction func boostAction(_ sender: UIButton) {
        initBoosts[index % arrayLen] += 1
        boostNumber.text = String(initBoosts[index % arrayLen])
    }
    
    /*
    @IBAction func playerController(_ sender: UIButton) {
        if(playVideo){
            playVideo = false
        }
        else{
            playVideo = true
        }
        
        videoPlay()
    }
 */
    
    
    
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
            //playVideo = false
            //videoPlay()
            //print(index)
            //playVideo = true
            //videoPlay()
            
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.down {
            playVideo = false
            videoPlay()
            index += 1
            boostNumber.text = String(initBoosts[index % arrayLen])
            viewerCount.text = String(viewers[index % arrayLen])
            nameLabel.text = people[index % arrayLen]
            streamLabel.text = challenges[index % arrayLen]
            avatarImage.image = avatars[index % arrayLen]
            
            
            playVideo = true
            videoPlay()
        }
    }
    
    
    func videoPlay(){
        var playerLayer = AVPlayerLayer(player: player)
        
        playerLayer.frame = self.view.bounds
       
        if(playVideo){
            player = AVPlayer(url: videoURL[index % arrayLen]!)
            
            
            
            self.view.layer.addSublayer(playerLayer)
            player?.play()
            
            
            
            if(index != 0){
                player = nil
                playerLayer = AVPlayerLayer(player: player)
                playerLayer.frame = self.view.bounds
                
                self.view.layer.addSublayer(playerLayer)
                //playerLayer.removeFromSuperlayer()
                
            }
        }
        else{
            player?.pause()
            player = nil
            var playerLayer = AVPlayerLayer(player: player)
            self.view.layer.addSublayer(playerLayer)
            
            
            
        }
        
        
        if(index % arrayLen == 1){
            fakeImage.image = #imageLiteral(resourceName: "hotdog")
            
        } else if(index % arrayLen == 2){
            fakeImage.image = #imageLiteral(resourceName: "flowers")
        } else{
            fakeImage.image = #imageLiteral(resourceName: "backflip")
        }
        
        
        }
    
    
    

    
    override func viewDidLoad() {
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        super.viewDidLoad()
        
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
        
        

        //to interact with side view controlle
        
        
        let menu = UIButton(frame: CGRect(x: 20, y: 35, width: 25, height: 25))
        //menu.setTitle("HI", for: .normal)
        //menu.backgroundColor = UIColor.red
        //menu.setTitleColor(UIColor.blue, for: .normal)
        menu.setImage(#imageLiteral(resourceName: "menu"), for: UIControlState.normal)
        
        menu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addSubview(menu)
        
        videoPlay()
 
        }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 */
 

}
 

/*
//
//  WatchViewController.swift
//  LiveStream
//
//  Created by Kirin Sinha Prior on 4/30/17.
//  Copyright © 2017 com.continuum. All rights reserved.
//

import UIKit

class WatchViewController: UIViewController, BambuserPlayerDelegate {
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
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        super.viewDidLoad()
        
        //to interact with side view controller
        
        let menu = UIButton(frame: CGRect(x: 20, y: 35, width: 25, height: 25))
        //menu.setTitle("HI", for: .normal)
        //menu.backgroundColor = UIColor.red
        //menu.setTitleColor(UIColor.blue, for: .normal)
        menu.setImage(#imageLiteral(resourceName: "menu"), for: UIControlState.normal)
        
        menu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addSubview(menu)
        
        // to add a simple video player to the screen
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
        rewindButton.addTarget(self, action: #selector(ViewController.rewind), for: UIControlEvents.touchUpInside)
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
 */
 


