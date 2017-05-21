//
//  SetPictureViewController.swift
//  LiveStream
//
//  Created by Kirin Sinha Prior on 5/14/17.
//  Copyright © 2017 com.continuum. All rights reserved.
//

import UIKit

protocol SetPictureViewControllerDelegate {
    func acceptData(data: UIImage)
}

class SetPictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    


    
    @IBOutlet weak var preview: UIImageView!
    
    @IBOutlet weak var takeButton: UIButton!
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var enterButton: UIButton!
    var delegate : SetPictureViewControllerDelegate?
    var storedImage: UIImage?
    
    
    @IBAction func close(_ sender: UIButton) {
        if storedImage != nil{
            self.delegate?.acceptData(data: storedImage!)
            self.view.removeFromSuperview()
        }
        }
        
    @IBAction func exit(_ sender: UIButton) {
        self.view.removeFromSuperview()
    }
    
    @IBAction func choosePhoto(_ sender: UIButton) {
        
        let photoLib = UIImagePickerController()
        photoLib.delegate = self
        photoLib.sourceType = UIImagePickerControllerSourceType.photoLibrary
        photoLib.allowsEditing = false
        photoLib.modalPresentationStyle = .popover
        self.present(photoLib, animated: true)
    }
    
    @IBAction func takePhoto(_ sender: UIButton) {
        
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
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            storedImage = image
            preview.image = storedImage
            preview.alpha = 1.0
            
        }
        else{
            print("problems")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.preview.layer.cornerRadius = self.preview.frame.size.width / 2;
        self.preview.clipsToBounds = true;
        
        self.preview.layer.borderWidth = 1.0;
        self.preview.layer.borderColor = UIColor.black.cgColor;
        
        self.view.backgroundColor = UIColor.black
        self.view.alpha = 0.9
        enterButton.backgroundColor = UIColor(red:0.13, green:0.75, blue:0.39, alpha:1.0)
        
        takeButton.setTitleColor(UIColor(red:0.13, green:0.75, blue:0.39, alpha:1.0), for: .normal )
        takeButton.titleLabel?.textColor = UIColor(red:0.13, green:0.75, blue:0.39, alpha:1.0)
        
        chooseButton.setTitleColor(UIColor(red:0.13, green:0.75, blue:0.39, alpha:1.0), for: .normal )
        chooseButton.titleLabel?.textColor = UIColor(red:0.13, green:0.75, blue:0.39, alpha:1.0)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
 */
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
