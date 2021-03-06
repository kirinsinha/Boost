//
//  ViewController.swift
//  LiveStream
//
//  Created by Alexander Lindsay on 4/17/17.
//  Copyright © 2017 com.continuum. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase
import AVFoundation
import Alamofire

class ViewController: UIViewController, BambuserViewDelegate, UITextFieldDelegate, PopupViewControllerDelegate {
    
    // Firebase
    
    var user: FIRUser? //Auth obj
    var u: User? //Database obj
    var ref: FIRDatabaseReference?
    var databaseHandle: FIRDatabaseHandle!
    var streamTitleText: String?
    
    @IBOutlet weak var blur: UIVisualEffectView!
    @IBOutlet weak var liveLabel: UILabel!

    @IBOutlet weak var viewersCount: UILabel!
    
    @IBOutlet weak var backgroundBar: UILabel!

    @IBOutlet weak var boostCount: UILabel!

    @IBOutlet weak var progressBar: UILabel!
    @IBOutlet weak var goalCount: UILabel!
    @IBOutlet weak var streamLabel: UILabel!
    @IBOutlet weak var outline1: UILabel!
    @IBOutlet weak var outline2: UILabel!
    
    var bambuserView : BambuserView
    var broadcastButton : UIButton
    var switchFlashButton: UIButton
    var changeCameraButton: UIButton
    var editButton: UIButton
    var blurBool = true
    var gradient: CAGradientLayer!
    let yellow = UIColor(red: 255.0/255.0, green: 200.0/255.0, blue: 94.0/255.0, alpha: 1.0)
    var fractionProgress = 0.0
    var goal = 0.0
    var backActive = true
    
    var input: AVCaptureDeviceInput!
    var currentCaptureDevice: AVCaptureDevice?




    func acceptData(data: [String]) {
        self.streamLabel.text = data[0]
        self.goalCount.text = data[1]
        if(blurBool) {
            blur.removeFromSuperview()
            blurBool = false 
        }
        broadcastButton.setImage(#imageLiteral(resourceName: "flash_green"), for: UIControlState.normal)
        broadcastButton.addTarget(self, action: #selector(ViewController.broadcast), for: UIControlEvents.touchUpInside)
        liveLabel.text = "Go Live!"
        liveLabel.textColor = UIColor.green
        
        let boost = Double(boostCount.text!)!
        goal = Double(goalCount.text!)!
        fractionProgress = boost / goal
        
        
        if(boost<=goal){
            let height = CGFloat(fractionProgress)*backgroundBar.bounds.size.height
            progressBar.frame = CGRect(x: backgroundBar.frame.minX, y: backgroundBar.frame.maxY - height, width: backgroundBar.bounds.size.width, height: height)
            gradient.removeFromSuperlayer()
            createGradient()
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
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        bambuserView = BambuserView(preset: kSessionPresetAuto)
        //bambuserView.applicationId = "tjcjYSpdtmV7gUK9cVUycg"
        bambuserView.applicationId = "Do14yFBjvRaFc8ut0Ri6LA"
        //broadcastButton = UIButton(type: UIButtonType.system)
        
        broadcastButton = UIButton(frame: CGRect(x: 300, y: 500, width: 65, height: 65))
        switchFlashButton = UIButton(frame: CGRect(x: 300, y: 500, width: 65, height: 65))
        changeCameraButton = UIButton(frame: CGRect(x: 300, y: 500, width: 65, height: 65))
        editButton = UIButton(frame: CGRect(x: 300, y: 500, width: 65, height: 65))
        super.init(coder: aDecoder)
        bambuserView.delegate = self;
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.user = FIRAuth.auth()?.currentUser
        
        //set current user database object
        
        DataService.dataService.CURRENT_USER_REF.observeSingleEvent(of: .value, with: { snapshot in
            
            self.u = User(snap: snapshot, userId: (self.user?.uid)!)
            
            print(self.u?.username ?? "no current user set")
            
        })
        
        
        //progress.transform = progress.transform.scaledBy(x: 1, y: 2)
        // Do any additional setup after loading the view, typically from a nib.
        bambuserView.orientation = UIApplication.shared.statusBarOrientation
        self.view.addSubview(bambuserView.view)
        self.view.sendSubview(toBack: bambuserView.view)

        //broadcastButton.setTitle("Broadcast", for: UIControlState.normal)
        broadcastButton.setImage(#imageLiteral(resourceName: "flash_white"), for: UIControlState.normal)
        self.view.addSubview(broadcastButton)
        switchFlashButton.setImage(#imageLiteral(resourceName: "flash_icon"), for: UIControlState.normal)
        self.view.addSubview(switchFlashButton)
        changeCameraButton.setImage(#imageLiteral(resourceName: "switch"), for: UIControlState.normal)
        self.view.addSubview(changeCameraButton)
        editButton.setImage(#imageLiteral(resourceName: "compose_white"), for: UIControlState.normal)
        self.view.addSubview(editButton)
        
        
        /*
        let popOverVC = UIStoryboard(name: "main", bundle: nil).instantiateViewController(withIdentifier: "popup") as! PopupViewController
        
        self.addChildViewController(popOverVC)
        
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        */
        
        //progress.progress = fractionProgress
        
        
        //broadcastButton.setImage(#imageLiteral(resourceName: "flash_green"), for: UIControlState.normal)
        //broadcastButton.addTarget(self, action: #selector(ViewController.broadcast), for: UIControlEvents.touchUpInside)
        
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

    
        //enterStream.addTarget(self, action: #selector(ViewController.submit), for: .touchUpInside)
        
        switchFlashButton.addTarget(self, action: #selector(ViewController.changeFlash), for: .touchUpInside)
        
        changeCameraButton.addTarget(self, action: #selector(ViewController.flipCamera), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(ViewController.edit), for: .touchUpInside)

        
        
        
        let menu = UIButton(frame: CGRect(x: 20, y: 35, width: 25, height: 25))
        menu.setImage(#imageLiteral(resourceName: "menu"), for: UIControlState.normal)
        
        menu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addSubview(menu)
        
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popup") as! PopupViewController
        popOverVC.delegate = self
        
        self.addChildViewController(popOverVC)
        
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
        let boost = Double(boostCount.text!)!
        goal = Double(goalCount.text!)!
        fractionProgress = boost / goal
        
        
        if(boost<=goal){
            let height = CGFloat(fractionProgress)*backgroundBar.bounds.size.height
            progressBar.frame = CGRect(x: backgroundBar.frame.minX, y: backgroundBar.frame.maxY - height, width: backgroundBar.bounds.size.width, height: height)
            createGradient()
        }
        
        bambuserView.swapCamera()
        
    }
    
    override func viewWillLayoutSubviews() {
        var statusBarOffset : CGFloat = 0.0
        statusBarOffset = CGFloat(self.topLayoutGuide.length)
        bambuserView.previewFrame = CGRect(x: 0.0, y: 0.0 + statusBarOffset, width: self.view.bounds.size.width, height: self.view.bounds.size.height - statusBarOffset)
        broadcastButton.frame = CGRect(x: 160, y: 545.0 + statusBarOffset, width: 60.0, height: 60.0);
        switchFlashButton.frame = CGRect(x: 335, y: 15.0 + statusBarOffset, width: 25.0, height: 25.0);
        changeCameraButton.frame = CGRect(x: 280, y: 15.0 + statusBarOffset, width: 25.0, height: 25.0);
        editButton.frame = CGRect(x: 340, y: 615.0 + statusBarOffset, width: 20.0, height: 20.0);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func edit(_ sender: UIButton) {
        //let blur = UIVisualEffectView()
        //blur.frame = self.view.bounds
        //self.view.addSubview(blur)
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popup") as! PopupViewController
        popOverVC.delegate = self
        
        self.addChildViewController(popOverVC)
        
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
    }

    
    func changeFlash(_ sender: UIButton) {
        if let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo), device.hasTorch {
            do {
                try device.lockForConfiguration()
                let torchOn = !device.isTorchActive
                try device.setTorchModeOnWithLevel(1.0)
                device.torchMode = torchOn ? .on : .off
                device.unlockForConfiguration()
            } catch {
                print("error")
            }
        }
    }
    
    func flipCamera(_ sender: UIButton) {
        
        bambuserView.swapCamera()
        
    }
    
    func broadcast() {
        NSLog("Starting broadcast")
        
        
        //broadcastButton.setTitle("Connecting", for: UIControlState.normal)
        
        broadcastButton.setImage(#imageLiteral(resourceName: "flash_red"), for: UIControlState.normal)
        broadcastButton.removeTarget(nil, action: nil, for: UIControlEvents.touchUpInside)
        broadcastButton.addTarget(bambuserView, action: #selector(bambuserView.stopBroadcasting), for: UIControlEvents.touchUpInside)
        
        bambuserView.startBroadcasting()
        
    }
    
    //called when server creates unique string. get metadata from the server based on 
    //id and then save to database
    
    func broadcastIdReceived(_ broadcastId: String!) {
        requestVideoMetadataAndCreate(broadcastId: broadcastId)
    }
    
    func requestVideoMetadataAndCreate(broadcastId: String!) {
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" :"Bearer d8vz5aqnewxk7i193gbze5dc3", //change api key here
            "Accept" : "application/vnd.bambuser.v1+json"
        ]
        
        
        Alamofire.request("https://api.irisplatform.io/broadcasts/" + broadcastId, headers: headers).responseJSON { response in
            debugPrint(response)
            if let result = response.result.value {
                let json = result as! NSDictionary
                let id = json["id"]!
                if id as? String != broadcastId {print("strange times")}
                var videoInfo = [:] as Dictionary<String, Any>
                videoInfo["url"] = json["resourceUri"]!
                videoInfo["videoTitle"] = self.streamLabel.text
                videoInfo["boostNum"] = 0
                videoInfo["boostGoal"] = self.goal
                videoInfo["creatorId"] = self.u?.userId
                videoInfo["creatorName"] = self.u?.username
                videoInfo["liveStatus"] = true
                DataService.dataService.createNewVideo(videoID: broadcastId, videoInfo: videoInfo)
                
                DataService.dataService.CURRENT_USER_REF.observeSingleEvent(of: .value, with: { snapshot in
                
                    let u = User(snap: snapshot, userId: (self.user?.uid)!)
                    
                    print(u.username)
                    u.createDeleteVideo(videoId: broadcastId, create: true)
                
                })
            }
        }
    }
    
    
    func broadcastStarted() {
        NSLog("Received broadcastStarted signal")
        
        //ref?.setValue("Test")
        
        //broadcastButton.setTitle("Stop", for: UIControlState.normal)
        broadcastButton.setImage(#imageLiteral(resourceName: "flash_red"), for: UIControlState.normal)
        liveLabel.text = "Live Now"
        liveLabel.textColor = UIColor.red
        broadcastButton.removeTarget(nil, action: nil, for: UIControlEvents.touchUpInside)
        broadcastButton.addTarget(bambuserView, action: #selector(bambuserView.stopBroadcasting), for: UIControlEvents.touchUpInside)
    }
    
    func broadcastStopped() {
        NSLog("Received broadcastStopped signal")
        //broadcastButton.setTitle("Broadcast", for: UIControlState.normal)
        broadcastButton.setImage(#imageLiteral(resourceName: "flash_green"), for: UIControlState.normal)
        liveLabel.text = "Go Live!"
        liveLabel.textColor = UIColor.green
        broadcastButton.removeTarget(nil, action: nil, for: UIControlEvents.touchUpInside)
        broadcastButton.addTarget(self, action: #selector(ViewController.broadcast), for: UIControlEvents.touchUpInside)
    }
    

}

