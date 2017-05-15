//
//  TestTopViewController.swift
//  LiveStream
//
//  Created by Kirin Sinha Prior on 5/15/17.
//  Copyright © 2017 com.continuum. All rights reserved.
//

import UIKit

protocol TestViewControllerDelegate {
    func acceptData(data: String)
}


class TestTopViewController: UIViewController {
    
    var delegate : TestViewControllerDelegate?

    @IBAction func go(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "here") ///as! TestFinalViewController
        
        //vc.delegate = self
        self.present(vc!, animated: true, completion: nil)
        
        
        
        
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.delegate?.acceptData(data: "testing")
        print("here")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
   

}
