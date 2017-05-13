//
//  RegisterViewController.swift
//  LiveStream
//
//  Created by Kirin Sinha Prior on 4/30/17.
//  Copyright © 2017 com.continuum. All rights reserved.
//



//used cocoapods and firebase: https://cocoapods.org/pods/Firebase
//https://firebase.google.com/docs/ios/setup
//documentation for firebase: https://firebase.google.com/docs/auth/

import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var profilePic: UIImageView!
    
    //register for an account using your email and firebase
    @IBAction func registerAccount(_ sender: UIButton) {
        FIRAuth.auth()?.createUser(withEmail: emailText.text!,password: passwordText.text!) { (user, error) in
            
            if let user = FIRAuth.auth()?.currentUser{
            let changeRequest = user.profileChangeRequest()
            changeRequest.displayName = self.nameText.text
            }
            
            if error == nil {
                print("Success")

                
                
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
    
    
    
    @IBAction func profPic(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let photo = UIImagePickerController()
            photo.delegate = self
            photo.sourceType = UIImagePickerControllerSourceType.camera
            photo.cameraCaptureMode = .photo
            photo.allowsEditing = false
            photo.modalPresentationStyle = .fullScreen
            self.present(photo, animated: true)
        } else {
            print("issue")
        }
        
    }
    
    @IBAction func choosePhoto(_ sender: UIButton) {
        let photoLib = UIImagePickerController()
        photoLib.delegate = self
        photoLib.sourceType = UIImagePickerControllerSourceType.photoLibrary
        photoLib.allowsEditing = false
        photoLib.modalPresentationStyle = .popover
        self.present(photoLib, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profilePic.contentMode = .scaleAspectFit
            profilePic.image = image
        }
        else{
            print("problems")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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
        nameText.setBottomBorder()
        passwordText.setBottomBorder()
        
        emailText.delegate = self
        nameText.delegate = self
        passwordText.delegate = self

        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}



