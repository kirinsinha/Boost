//
//  TestFinalViewController.swift
//  LiveStream
//
//  Created by Kirin Sinha Prior on 5/15/17.
//  Copyright © 2017 com.continuum. All rights reserved.
//

import UIKit


class TestFinalViewController: UIViewController, TestViewControllerDelegate {
    
    @IBOutlet weak var label: UILabel!
    
    func acceptData(data: String) {
        self.label.text = data
        print("here2")
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
