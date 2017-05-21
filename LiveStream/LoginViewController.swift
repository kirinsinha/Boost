//
//  LoginViewController.swift
//  LiveStream
//
//  Created by Kirin Sinha Prior on 4/30/17.
//  Copyright © 2017 com.continuum. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    //check firebase credentials for email login
    @IBAction func Login(_ sender: UIButton) {
        
        FIRAuth.auth()?.signIn(withEmail: self.emailText.text!, password: self.passwordText.text!) { (user, error) in
            
            if error == nil {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "start")
                self.present(vc!, animated: true, completion: nil)
                
            } else {
                
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        
            
        }
    }

    func dismissKeyboard() {
        view.endEditing(true)
        UIView.animate(withDuration: 0.05, animations: {
            var frame = self.nextButton.frame
            frame.origin.y = 587
            self.nextButton.frame = frame
        })
    }
    
    
    
    
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.1, animations: {
            var frame = self.nextButton.frame
            frame.origin.y = 375
            self.nextButton.frame = frame
        })
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailText.setBottomBorder()
        passwordText.setBottomBorder()
        
        emailText.delegate = self
        passwordText.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        //self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
