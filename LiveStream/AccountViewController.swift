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
import StoreKit

//, SKProductsRequestDelegate,SKPaymentTransactionObserver

class AccountViewController: UIViewController{
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var boostNum: UILabel!
    @IBOutlet weak var numVideos: UILabel!
    
    
    @IBOutlet weak var getBoosts: UIButton!
    
    @IBOutlet weak var tenBoosts: UIButton!
    
    @IBOutlet weak var fiftyBoosts: UIButton!
    
    @IBOutlet weak var hundredBoosts: UIButton!
    
    var boosts = 0
    var addition = 0
    
    /*var list = [SKProduct]()
    var p = SKProduct()
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("product request")
        let myProduct = response.products
        for product in myProduct{
            print("product added")
            print(product.productIdentifier)
            print(product.localizedTitle)
            print(product.localizedDescription)
            print(product.price)
            
            list.append(product)
        }
        
        
    }
 */
    
    
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
        addition = 10
        showAlert(message: "Buying 10 boosts for $0.99.                                                                     [Environment: Sandbox]")
    }
    
    @IBAction func addFifty(_ sender: UIButton) {
        print("50")
        addition = 50
        showAlert(message: "Buying 50 boosts for $4.99.                                                                     [Environment: Sandbox]")
    }
    
    @IBAction func addHundred(_ sender: UIButton) {
        print("100")
        addition = 100
        showAlert(message: "Buying 100 boosts for $9.99.                                                                     [Environment: Sandbox]")
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
        
        //productIDs.append("com.Kirin.LiveStream.10Boosts")
        //productIDs.append("com.Kirin.LiveStream.50Boosts")
        //productIDs.append("com.Kirin.LiveStream.100Boosts")
        
        numVideos.text = "7"
        boostNum.text = "68"
        nameLabel.text = "Molly Bootman"
        profilePic.image = #imageLiteral(resourceName: "avatar")
        
        
        
        
        let menu = UIButton(frame: CGRect(x: 20, y: 35, width: 25, height: 25))
        menu.setImage(#imageLiteral(resourceName: "menu"), for: UIControlState.normal)
        
        menu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addSubview(menu)
        
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert(message: String!) {
        let alertController = UIAlertController(title: "Confirm Your In-App Purchase", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let buy = UIAlertAction(title: "Buy", style: .default, handler: { (action) -> Void in
            self.showConfirmation(message: "Your purchase was successful.                [Environment: Sandbox]")
            self.boosts = Int(self.boostNum.text!)!
            self.boosts += self.addition
            self.boostNum.text = String(self.boosts)
            
            
        })
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        alertController.addAction(buy)
        
        present(alertController, animated: true)
    }
    
    func showConfirmation(message: String!) {
        let alertController = UIAlertController(title: "You are all set", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        present(alertController, animated: true)
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
