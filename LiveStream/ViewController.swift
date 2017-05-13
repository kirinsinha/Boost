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

class ViewController: UIViewController, BambuserViewDelegate, UITextFieldDelegate {
    
    // Firebase
    
    var user: FIRUser?
    var ref: FIRDatabaseReference?
    
    
    @IBOutlet weak var flashLabel: UILabel!
    @IBOutlet weak var liveLabel: UILabel!
    @IBOutlet weak var boostCount: UILabel!
    @IBOutlet weak var viewersCount: UILabel!
    @IBOutlet weak var enterStream: UIButton!
    @IBOutlet weak var streamTitle: UIButton!
    @IBOutlet weak var goalTitle: UIButton!
    @IBOutlet weak var progress: UIProgressView!
    //@IBOutlet weak var broadcastButton: UIButton!
    
    var bambuserView : BambuserView
    var broadcastButton : UIButton
    var switchFlashButton: UIButton
    var changeCameraButton: UIButton
    var titleSet = false
    var goalVal = false
    var goalNum = 100.0
    var fractionProgress = 0.0
    var textField: UITextField = UITextField(frame: CGRect(x: 0, y: 350, width: 300.00, height: 65.00));
    
    
    
    @IBAction func setStream(_ sender: UIButton) {
        textField.backgroundColor = UIColor.white
        self.view.addSubview(textField)
        self.textField.becomeFirstResponder()
        self.textField.text = ""
        var frame = self.enterStream.frame
        frame.origin.y = 350
        self.enterStream.frame = frame
        enterStream.alpha = 1
        
        textField.isHidden = false
 
    }
    
    
    @IBAction func setGoal(_ sender: UIButton) {
        goalVal = true
        textField.backgroundColor = UIColor.white
        self.view.addSubview(textField)
        self.textField.becomeFirstResponder()
        self.textField.text = ""
        var frame = self.enterStream.frame
        frame.origin.y = 350
        self.enterStream.frame = frame
        enterStream.alpha = 1
        
        textField.isHidden = false
        
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        bambuserView = BambuserView(preset: kSessionPresetAuto)
        //bambuserView.applicationId = "tjcjYSpdtmV7gUK9cVUycg"
        bambuserView.applicationId = "Do14yFBjvRaFc8ut0Ri6LA"
        //broadcastButton = UIButton(type: UIButtonType.system)
        
        broadcastButton = UIButton(frame: CGRect(x: 300, y: 500, width: 65, height: 65))
        switchFlashButton = UIButton(frame: CGRect(x: 300, y: 500, width: 65, height: 65))
        changeCameraButton = UIButton(frame: CGRect(x: 300, y: 500, width: 65, height: 65))
        super.init(coder: aDecoder)
        bambuserView.delegate = self;
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference()
        
        progress.transform = progress.transform.scaledBy(x: 1, y: 2)
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
        
        
        //progress.progress = fractionProgress
        
        
        //broadcastButton.setImage(#imageLiteral(resourceName: "flash_green"), for: UIControlState.normal)
        //broadcastButton.addTarget(self, action: #selector(ViewController.broadcast), for: UIControlEvents.touchUpInside)
        
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

    
        enterStream.addTarget(self, action: #selector(ViewController.submit), for: .touchUpInside)
        
        switchFlashButton.addTarget(self, action: #selector(ViewController.changeFlash), for: .touchUpInside)
        
        changeCameraButton.addTarget(self, action: #selector(ViewController.flipCamera), for: .touchUpInside)
        

        
        
        let menu = UIButton(frame: CGRect(x: 20, y: 35, width: 25, height: 25))
        menu.setImage(#imageLiteral(resourceName: "menu"), for: UIControlState.normal)
        
        menu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addSubview(menu)
        
    }
    
    override func viewWillLayoutSubviews() {
        var statusBarOffset : CGFloat = 0.0
        statusBarOffset = CGFloat(self.topLayoutGuide.length)
        bambuserView.previewFrame = CGRect(x: 0.0, y: 0.0 + statusBarOffset, width: self.view.bounds.size.width, height: self.view.bounds.size.height - statusBarOffset)
        broadcastButton.frame = CGRect(x: 160, y: 515.0 + statusBarOffset, width: 65.0, height: 65.0);
        switchFlashButton.frame = CGRect(x: 255, y: 532.0 + statusBarOffset, width: 25.0, height: 25.0);
        changeCameraButton.frame = CGRect(x: 28, y: 532.0 + statusBarOffset, width: 25.0, height: 25.0);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
 
    
    func submit(){
        
        if(textField.text != ""){
            titleSet = true
            if goalVal{
                goalTitle.backgroundColor = UIColor.white
                goalTitle.setTitleColor(UIColor.blue, for: UIControlState.normal)
                goalTitle.setTitle(textField.text!, for: UIControlState.normal)
                goalNum = Double(textField.text!) ?? 1.0
                goalVal = false
                let boost = Double(boostCount.text!)!
                fractionProgress = boost / goalNum
                progress.progress = Float(fractionProgress)
                
            } else{
            streamTitle.backgroundColor = UIColor.white
            streamTitle.setTitleColor(UIColor.black, for: UIControlState.normal)
            streamTitle.setTitle("    " + textField.text!, for: UIControlState.normal)
            }
            

            enterStream.alpha = 0
            textField.isHidden = true
            textField.resignFirstResponder()
            
        }else{
            titleSet = false
            enterStream.alpha = 0
            textField.isHidden = true
            textField.resignFirstResponder()
            streamTitle.backgroundColor = UIColor.blue
            streamTitle.setTitleColor(UIColor.white, for: UIControlState.normal)
            streamTitle.setTitle("          SET YOUR LIVE STREAM TITLE", for: UIControlState.normal)

            enterStream.alpha = 0
            textField.isHidden = true
            textField.resignFirstResponder()
            
            broadcastButton.setImage(#imageLiteral(resourceName: "flash_white"), for: UIControlState.normal)
            broadcastButton.removeTarget(nil, action: nil, for: UIControlEvents.touchUpInside)
            liveLabel.text = "Not Live"
            liveLabel.textColor = UIColor.lightGray
            
        }
        
        if(titleSet){
            broadcastButton.setImage(#imageLiteral(resourceName: "flash_green"), for: UIControlState.normal)
            broadcastButton.addTarget(self, action: #selector(ViewController.broadcast), for: UIControlEvents.touchUpInside)
            liveLabel.text = "Go Live!"
            liveLabel.textColor = UIColor.green
        }
        
    }
    

}

