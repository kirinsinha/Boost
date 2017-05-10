//
//  AccountViewController.swift
//  LiveStream
//
//  Created by Kirin Sinha Prior on 5/1/17.
//  Copyright © 2017 com.continuum. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AccountViewController: UIViewController {
    
    
    @IBOutlet weak var getBoosts: UIButton!
    
    @IBOutlet weak var tenBoosts: UIButton!
    
    @IBOutlet weak var fiftyBoosts: UIButton!
    
    @IBOutlet weak var hundredBoosts: UIButton!
    
    
    @IBAction func getMore(_ sender: UIButton) {
        if getBoosts.frame == tenBoosts.frame {
            tenBoosts.frame = CGRect(x:getBoosts.frame.origin.x, y: getBoosts.frame.origin.y + 50, width: 315, height: 50)
            fiftyBoosts.frame = CGRect(x:getBoosts.frame.origin.x, y: getBoosts.frame.origin.y + 100, width: 315, height: 50)
            hundredBoosts.frame = CGRect(x:getBoosts.frame.origin.x, y: getBoosts.frame.origin.y + 150, width: 315, height: 50)
        } else {
            tenBoosts.frame = getBoosts.frame
            fiftyBoosts.frame = getBoosts.frame
            hundredBoosts.frame = getBoosts.frame
        }
        
        
    }
    
    @IBAction func addTen(_ sender: UIButton) {
        print("10")
    }
    
    @IBAction func addFifty(_ sender: UIButton) {
        print("50")
    }
    
    @IBAction func addHundred(_ sender: UIButton) {
        print("100")
    }
    
    
    @IBAction func logout(_ sender: UIButton) {
    if FIRAuth.auth()?.currentUser != nil {
    do {
    try FIRAuth.auth()?.signOut()
    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homepage")
    present(vc, animated: false, completion: nil)
    
    } catch let error as NSError {
    print(error.localizedDescription)
    }
    }
    }
    
    

    
    

    override func viewDidLoad() {
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        super.viewDidLoad()
        
        //to interact with side view controller
        
        
        let initFrame = getBoosts.frame
        tenBoosts.frame = initFrame
        fiftyBoosts.frame = initFrame
        hundredBoosts.frame = initFrame
        
        
        
        
        let menu = UIButton(frame: CGRect(x: 20, y: 35, width: 25, height: 25))
        menu.setImage(#imageLiteral(resourceName: "menu"), for: UIControlState.normal)
        
        menu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addSubview(menu)
        
        
        
        
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
