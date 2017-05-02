//
//  ViewController.swift
//  LiveStream
//
//  Created by Alexander Lindsay on 4/17/17.
//  Copyright © 2017 com.continuum. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BambuserViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var flashLabel: UILabel!
    @IBOutlet weak var liveLabel: UILabel!
    @IBOutlet weak var boostCount: UILabel!
    @IBOutlet weak var viewersCount: UILabel!
    @IBOutlet weak var enterStream: UIButton!
    @IBOutlet weak var compose: UIButton!
    @IBOutlet weak var streamTitle: UIButton!
    
    var bambuserView : BambuserView
    var broadcastButton : UIButton
    var titleSet = false
    var textField: UITextField = UITextField(frame: CGRect(x: 0, y: 350, width: 300.00, height: 65.00));
    
    
    
    @IBAction func setStream(_ sender: UIButton) {
        textField.backgroundColor = UIColor.white
        self.view.addSubview(textField)
        self.textField.becomeFirstResponder()
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
        
        broadcastButton = UIButton(frame: CGRect(x: 300, y: 300, width: 65, height: 65))
        super.init(coder: aDecoder)
        bambuserView.delegate = self;
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
        bambuserView.orientation = UIApplication.shared.statusBarOrientation
        self.view.addSubview(bambuserView.view)
        self.view.sendSubview(toBack: bambuserView.view)

        //broadcastButton.setTitle("Broadcast", for: UIControlState.normal)
        broadcastButton.setImage(#imageLiteral(resourceName: "flash_white"), for: UIControlState.normal)
        self.view.addSubview(broadcastButton)
        
        
        //broadcastButton.setImage(#imageLiteral(resourceName: "flash_green"), for: UIControlState.normal)
        //broadcastButton.addTarget(self, action: #selector(ViewController.broadcast), for: UIControlEvents.touchUpInside)
        
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

    
        enterStream.addTarget(self, action: #selector(ViewController.submit), for: .touchUpInside)
        

        
        
        let menu = UIButton(frame: CGRect(x: 20, y: 35, width: 25, height: 25))
        menu.setImage(#imageLiteral(resourceName: "menu"), for: UIControlState.normal)
        
        menu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addSubview(menu)
        
        
        
        
        
        
    }
    
    override func viewWillLayoutSubviews() {
        var statusBarOffset : CGFloat = 0.0
        statusBarOffset = CGFloat(self.topLayoutGuide.length)
        bambuserView.previewFrame = CGRect(x: 0.0, y: 0.0 + statusBarOffset, width: self.view.bounds.size.width, height: self.view.bounds.size.height - statusBarOffset)
        broadcastButton.frame = CGRect(x: 160, y: 500.0 + statusBarOffset, width: 65.0, height: 65.0);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            streamTitle.backgroundColor = UIColor.white
            streamTitle.setTitleColor(UIColor.black, for: UIControlState.normal)
            streamTitle.setTitle("    " + textField.text!, for: UIControlState.normal)

            compose.setImage(#imageLiteral(resourceName: "compose"), for: UIControlState.normal)
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
            
            compose.setImage(#imageLiteral(resourceName: "compose"), for: UIControlState.normal)
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

