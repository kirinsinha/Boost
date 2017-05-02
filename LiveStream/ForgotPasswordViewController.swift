//
//  ForgotPasswordViewController.swift
//  LiveStream
//
//  Created by Kirin Sinha Prior on 4/30/17.
//  Copyright © 2017 com.continuum. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {
    

    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    //send an email with password reset using firebase
    @IBAction func resetPassword(_ sender: UIButton) {
        FIRAuth.auth()?.sendPasswordReset(withEmail: self.emailText.text!, completion: { (error) in
            
            var title = ""
            var message = ""
            
            if error != nil {
                title = "Error!"
                message = (error?.localizedDescription)!
            } else {
                title = "Success!"
                message = "Password reset email sent."
                self.emailText.text = ""
            }
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        })

        
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
        emailText.delegate = self 
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ForgotPasswordViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
