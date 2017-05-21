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
    
    
    var cvidx = 0
    var fractionProgress = 0.0
    var goal = 0.0
    
    var user: FIRUser? //Auth obj
    var u: User! //current user holder Database obj
    var videos = [Video]()
    
    var challenges = ["Dog attacks doll", "Eating 10 hot dogs 🌭🍴💪", "Giving flowers to a stranger 😇💐"]
    
    var people = ["Molly Bootman", "Karen O'Rielly", "John Doe"]
    
    var initBoosts = [16,119,5]
    var avatars = [#imageLiteral(resourceName: "avatar"),#imageLiteral(resourceName: "avatar2"),#imageLiteral(resourceName: "avatar3")]
    var viewers = [563, 66, 228]
    var goalBoosts = [50,300,10]
    //var prevRegister = false
    
    var arrayLen = 1
    
    var bambuserPlayer : BambuserPlayer
    var playButton: UIButton
    var pauseButton: UIButton
    var rewindButton: UIButton
    var gradient: CAGradientLayer!
    var gradValue = 5
    var first : Bool?
    
    let yellow = UIColor(red: 255.0/255.0, green: 200.0/255.0, blue: 94.0/255.0, alpha: 1.0)
    
    required init?(coder aDecoder: NSCoder) {
        bambuserPlayer = BambuserPlayer()
        playButton = UIButton(type: UIButtonType.system)
        pauseButton = UIButton(type: UIButtonType.system)
        rewindButton = UIButton(type: UIButtonType.system)
        super.init(coder: aDecoder)
    }
    
    
    func removeInstruction() {
        
        if first == true {
            topView.removeFromSuperview()
            first = false
        }
        
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
        let pastIndex = cvidx
        
        FIRAnalytics.logEvent(withName: "swiped", parameters: nil)
        
        if gesture.direction == UISwipeGestureRecognizerDirection.up {
            cvidx -= 1
            
            
            if(cvidx < 0){
                cvidx = cvidx + videos.count
            }
        } else if gesture.direction == UISwipeGestureRecognizerDirection.down {
            cvidx += 1
        }
        
        //update previous video
        if pastIndex != cvidx {
            videos[pastIndex % videos.count].addRemoveViewers(add: false)
        }
        
        //update the new current video
        videos[cvidx % videos.count].addRemoveViewers(add: true)
    
        //draw the new current video
        renderPlayerForCurrentVideo()
    }
    
    
    
    func boostAction(_ sender: UIButton) {
        
        let videoId = videos[cvidx % videos.count].videoID
        u.addUndoBoost(videoId: videoId, boost: true)
        videos[cvidx % videos.count].addBoost()
        boostNumber.text = String(videos[cvidx % videos.count].boostNum)
        
        FIRAnalytics.logEvent(withName: "boostAction", parameters: nil)
    
        renderBoostBarUpdate()
        
    }

    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        FIRAnalytics.logEvent(withName: "WatchControllerStarted", parameters: nil)

        
        //intro if register was first view controller:
        let isFirstTime = UserDefaults.standard.bool(forKey: "firstUse")
        
        if isFirstTime != true {
            first = false
            topView.removeFromSuperview()
        } else {
            first = true
            UserDefaults.standard.set(false, forKey: "firstUse")
        }
        
        


        
        //Make sure the super actually grabs the real current user
        if self.u == nil {
            self.user = FIRAuth.auth()?.currentUser
            
            //set current user database object
            
            DataService.dataService.CURRENT_USER_REF.observeSingleEvent(of: .value, with: { snapshot in
                
                self.u = User(snap: snapshot, userId: (self.user?.uid)!)
                
                print(self.u?.username ?? "no current user set")
                
            })
        }
        
        //Listen to the list of videos, grab them and store them in the video list. Don't be smart about ordering for now.
        
        DataService.dataService.VIDEO_REF.observeSingleEvent(of: .value, with: { snapshot in
            
            self.videos = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    //create our array of videos
                    if let videoInfo = snap.value as? Dictionary<String, AnyObject> {
                        let id = snap.key
                        let vid = Video(videoID: id, videoInfo: videoInfo)
                        
                        //inserts videos newest joke first, likely have to update for sorting
                        self.videos.insert(vid, at:0)
                    }
                }
            }
            
            if self.videos.count == 0 {
                //display no video warning
                
            } else {
                self.renderPlayerForCurrentVideo()
            }
            
        })
        
        //add a listener for new videos
        
        DataService.dataService.VIDEO_REF.observe(.childAdded, with: { (snapshot) -> Void in
            if let videoInfo = snapshot.value as? Dictionary<String, AnyObject> {
                let id = snapshot.key
                let vid = Video(videoID: id, videoInfo: videoInfo)
                
                self.videos.append(vid)
            }
            
        })
        
        //add a listener for new updates to videos. If it's the current video, update your UI. If its a video in the queue
        //update the storage object
        
        DataService.dataService.VIDEO_REF.observe(.childChanged, with: { (snapshot) in
            let videoId = snapshot.ref.key
            //understand if its the current video or not to have different behavior
            var i = 0
            var idx = 0
            for video in self.videos {
                if video.videoID == videoId {
                    idx = i
                }
                i += 1
            }
            var currentVideoUpdate = false
            if idx == self.cvidx {currentVideoUpdate = true}
            
            let childName = snapshot.key
            if childName == "boostNum" {
                self.videos[idx].setBoost(num: snapshot.value as! Int)
            }
            if childName == "currentViewers" {
                self.videos[idx].setViewers(num: snapshot.value as! Int)
            }
            if childName == "liveStatus" {
                self.videos[idx].setLiveStatus(status: snapshot.value as! Bool)
            }
            
            if currentVideoUpdate {
                self.renderPlayerForCurrentVideo()
            }
        })
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
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

 
        
        let menu = UIButton(frame: CGRect(x: 20, y: 35, width: 25, height: 25))
        menu.setImage(#imageLiteral(resourceName: "menu"), for: UIControlState.normal)
        
        menu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addSubview(menu)
 
    }
    
    func renderPlayerForCurrentVideo() {
        let currentVideo = videos[cvidx % videos.count]
        boostNumber.text = String(currentVideo.boostNum)
        viewerCount.text = String(currentVideo.currentViewers)
        goalNumber.text = String(currentVideo.boostGoal)
        nameLabel.text = currentVideo.username
        streamLabel.text = currentVideo.videoTitle
    
        //avatarImage.image = avatars[cvidx % 3]
        
        let playerFrame = CGRect(x: 0, y: 150, width: self.view.frame.size.width, height: self.view.frame.size.height * 0.5)
        bambuserPlayer.frame = playerFrame
        
        bambuserPlayer.delegate = self
        bambuserPlayer.applicationId = "Do14yFBjvRaFc8ut0Ri6LA"
        
        bambuserPlayer.playVideo(currentVideo.irisURL)
        
        bambuserPlayer.isUserInteractionEnabled = false
        
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

    func renderBoostBarUpdate() {
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
 


 


