//
//  PopupViewController.swift
//  LiveStream
//
//  Created by Kirin Sinha Prior on 5/13/17.
//  Copyright © 2017 com.continuum. All rights reserved.
//

import UIKit


protocol PopupViewControllerDelegate {
    func acceptData(data: [String])
}


class PopupViewController: UIViewController {
    
    
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var challenge: UITextField!
    var titleSet = false
    var goalVal = false

    
    
    var goalNum = 100.0
    var fractionProgress = 0.0
    
    var delegate : PopupViewControllerDelegate?
    
    
    /*
    @IBAction func setStream(_ sender: UIButton) {
        
        
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
    
    
    func submit(){
        
        if(textField.text != ""){
            titleSet = true
            if goalVal{
                goalTitle.backgroundColor = UIColor.white
                goalTitle.setTitleColor(UIColor.blue, for: UIControlState.normal)
                goalTitle.setTitle(textField.text!, for: UIControlState.normal)
                goalNum = Double(textField.text!) ?? 1.0
                goalVal = false
                //let boost = Double(boostCount.text!)!
                //fractionProgress = boost / goalNum
                //progress.progress = Float(fractionProgress)
                
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
            
            /*
            
            broadcastButton.setImage(#imageLiteral(resourceName: "flash_white"), for: UIControlState.normal)
            broadcastButton.removeTarget(nil, action: nil, for: UIControlEvents.touchUpInside)
            liveLabel.text = "Not Live"
            liveLabel.textColor = UIColor.lightGray
 
 */
            
        }
        
        if(titleSet){
            /*
            broadcastButton.setImage(#imageLiteral(resourceName: "flash_green"), for: UIControlState.normal)
            broadcastButton.addTarget(self, action: #selector(ViewController.broadcast), for: UIControlEvents.touchUpInside)
            liveLabel.text = "Go Live!"
            liveLabel.textColor = UIColor.green
 */
        }
        
    }
*/
    
    @IBAction func close(_ sender: UIButton) {
        checkTitle()
        checkNumber()
        
        if(goalVal && titleSet){
            self.view.removeFromSuperview()
        }
        
    }
    
    func checkNumber() {
        if(amount.text != ""){
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: amount.text!)
        goalVal = allowedCharacters.isSuperset(of: characterSet)
        }
        
    }
    
    func checkTitle(){
        if(challenge.text != ""){
            titleSet = true
        } else {
            titleSet = false
        }
    }
 
 
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor.black
        self.view.alpha = 0.9
        self.topView.alpha = 1.0
        challenge.setBottomBorder()
        amount.setBottomBorder()
        enterButton.backgroundColor = UIColor(red:0.13, green:0.75, blue:0.39, alpha:1.0)
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
            self.delegate?.acceptData(data: [challenge.text!, amount.text!])
    }
 
 

}
