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

class ViewController: UIViewController, BambuserViewDelegate, UITextFieldDelegate, PopupViewControllerDelegate {
    
    // Firebase
    
    var user: FIRUser?
    var ref: FIRDatabaseReference?
    
    
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
        
        user = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference()
        
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

        print("flip")
        
        
        let discovery = AVCaptureDeviceDiscoverySession.init(deviceTypes: [AVCaptureDeviceType.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: AVCaptureDevicePosition.front)
        
        for device in (discovery?.devices)! {
            print(device)
            if device.position == .back {
            print("here1")
            }
            else if device.position == .front {
                print("here2")
            }
            
            currentCaptureDevice = device
        }
        
        do {
            input = try AVCaptureDeviceInput(device: currentCaptureDevice)
        }catch let error1 as NSError {
            
        }
        
 
    }
    
    func broadcast() {
        NSLog("Starting broadcast")
        
        //broadcastButton.setTitle("Connecting", for: UIControlState.normal)
        broadcastButton.setImage(#imageLiteral(resourceName: "flash_red"), for: UIControlState.normal)
        broadcastButton.removeTarget(nil, action: nil, for: UIControlEvents.touchUpInside)
        broadcastButton.addTarget(bambuserView, action: #selector(bambuserView.stopBroadcasting), for: UIControlEvents.touchUpInside)
        bambuserView.startBroadcasting()
    }
    
    func broadcastStarted() {
        NSLog("Received broadcastStarted signal")
        
        ref?.setValue("Test")
        
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

