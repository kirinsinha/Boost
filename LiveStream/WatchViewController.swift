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
    @IBOutlet weak var indicatorLabel: UILabel!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var streamLabel: UILabel!
    
    @IBOutlet weak var viewerCount: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    

    @IBOutlet weak var goalNumber: UILabel!

    @IBOutlet weak var progressBar: UILabel!
    
    @IBOutlet weak var backgroundBar: UILabel!
    
    
    var index = 0
    var fractionProgress = 0.0
    var goal = 0.0
    
    var challenges = ["Dog attacks doll", "Eating 10 hot dogs 🌭🍴💪", "Giving flowers to a stranger 😇💐"]
    
    var people = ["Molly Bootman", "Karen O'Rielly", "John Doe"]
    
    var initBoosts = [16,119,5]
    var avatars = [#imageLiteral(resourceName: "avatar"),#imageLiteral(resourceName: "avatar2"),#imageLiteral(resourceName: "avatar3")]
    var viewers = [563, 66, 228]
    var goalBoosts = [50,300,10]
    var prevRegister = false

    
    var arrayLen = 1
    
    var bambuserPlayer : BambuserPlayer
    var playButton: UIButton
    var pauseButton: UIButton
    var rewindButton: UIButton
    var gradient: CAGradientLayer!
    var gradValue = 5
    var first = true
    
    let yellow = UIColor(red: 255.0/255.0, green: 200.0/255.0, blue: 94.0/255.0, alpha: 1.0)
    
    required init?(coder aDecoder: NSCoder) {
        bambuserPlayer = BambuserPlayer()
        playButton = UIButton(type: UIButtonType.system)
        pauseButton = UIButton(type: UIButtonType.system)
        rewindButton = UIButton(type: UIButtonType.system)
        super.init(coder: aDecoder)
    }
    
    
    
    
    func removeInstruction(_ sender: UIButton) {
        
        if(first){
            topView.removeFromSuperview()
            first = false
        }
        
    }
    
    

    
    func boostAction(_ sender: UIButton) {
        
        initBoosts[index % arrayLen] += 1
        boostNumber.text = String(initBoosts[index % arrayLen])
        
        
        let boost = Double(boostNumber.text!)!
        goal = Double(goalNumber.text!)!
        fractionProgress = boost / goal

        
        if(boost<=goal){
            let height = CGFloat(fractionProgress)*backgroundBar.bounds.size.height
            progressBar.frame = CGRect(x: backgroundBar.frame.minX, y: backgroundBar.frame.maxY - height, width: backgroundBar.bounds.size.width, height: height)
            gradient.removeFromSuperlayer()
            createGradient()
        }
        
        UIView.animate(withDuration: 1, animations: {
            self.indicatorLabel.alpha = 1
        })
        
        UIView.animate(withDuration: 1, animations: {
            self.indicatorLabel.alpha = 0
        })
 
    }
    
    func createGradient() {
        gradient = CAGradientLayer()
        gradient.frame = progressBar.frame
        
        
        gradient.colors = [UIColor.red.cgColor,UIColor.orange.cgColor, yellow.cgColor]
        
        // 255,200,94
        gradient.locations = [0.0, 0.5, 1.0]
        
        
  self.view.layer.insertSublayer(gradient, at: 5)
        //gradValue += 1
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
        }
        

            
        
        else if gesture.direction == UISwipeGestureRecognizerDirection.down {
            index += 1

        }
        
        boostNumber.text = String(initBoosts[index % arrayLen])
        viewerCount.text = String(viewers[index % arrayLen])
        nameLabel.text = people[index % arrayLen]
        streamLabel.text = challenges[index % arrayLen]
        avatarImage.image = avatars[index % arrayLen]
        goalNumber.text = String(goalBoosts[index % arrayLen])
        
        gradient.removeFromSuperlayer()
        
        
        let boost = Double(boostNumber.text!)!
        goal = Double(goalNumber.text!)!
        fractionProgress = boost / goal
        
        
        if(boost<=goal){
            let height = CGFloat(fractionProgress)*backgroundBar.bounds.size.height
            progressBar.frame = CGRect(x: backgroundBar.frame.minX, y: backgroundBar.frame.maxY - height, width: backgroundBar.bounds.size.width, height: height)
            
            createGradient()

    }
 
 
    
    }
    

    
    

    
    override func viewDidLoad() {
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
 
        super.viewDidLoad()
        
        //intro if register was first view controller: 

        
        print(prevRegister)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(boostAction))
        doubleTap.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(doubleTap)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(removeInstruction))
        tap.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tap)
        
        if(!prevRegister){
            topView.removeFromSuperview()
        }
        
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
        
        self.view.sendSubview(toBack: bambuserPlayer)

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
        

        
        let boost = Double(boostNumber.text!)!
        goal = Double(goalNumber.text!)!
        fractionProgress = boost / goal
        
        
        if(boost<=goal){
            let height = CGFloat(fractionProgress)*backgroundBar.bounds.size.height
            progressBar.frame = CGRect(x: backgroundBar.frame.minX, y: backgroundBar.frame.maxY - height, width: backgroundBar.bounds.size.width, height: height)
            createGradient()

            
        }
        
        indicatorLabel.backgroundColor = yellow
 

        
 
        }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
 


 


