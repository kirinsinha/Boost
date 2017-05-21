

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
    
    
    @IBOutlet weak var backgroundImage: UIImageView!
    

    
    var boosts = 0
    var addition = 0
    var picture: UIImage?
    
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
        let actionSheet = UIAlertController(title: "", message: "Boost Up", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        //twitter action using social frameworks
        let ten = UIAlertAction(title: "10 Boosts", style: UIAlertActionStyle.default) { (action) -> Void in
            self.addTen()
        }
        
        //facebook action using social frameworks
        let fifty = UIAlertAction(title: "50 Boosts", style: UIAlertActionStyle.default) { (action) -> Void in
            self.addFifty()
            
        }
        
        //more button lets you access the Activity View Controller and remove the fb and twitter options
        let hundred = UIAlertAction(title: "100 Boosts", style: UIAlertActionStyle.default) { (action) -> Void in
            self.addHundred()
        }
        
        // close action
        let close = UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel) { (action) -> Void in
        }
        
        
        
        //action sheet
        actionSheet.addAction(ten)
        actionSheet.addAction(fifty)
        actionSheet.addAction(hundred)
        actionSheet.addAction(close)
        present(actionSheet, animated: true, completion: nil)
        
        FIRAnalytics.logEvent(withName: "getBoosts", parameters: nil)
        
        
    }
    
    func addTen() {
        addition = 10
        showAlert(message: "Buying 10 boosts for $0.99.                                                                     [Environment: Sandbox]")
        FIRAnalytics.logEvent(withName: "boostsAdded", parameters: ["amount": 10])

    }
    
    func addFifty() {
        addition = 50
        showAlert(message: "Buying 50 boosts for $4.99.                                                                     [Environment: Sandbox]")
        FIRAnalytics.logEvent(withName: "boostsAdded", parameters: ["amount": 50])

    }
    
   func addHundred() {
        addition = 100
        showAlert(message: "Buying 100 boosts for $9.99.                                                                     [Environment: Sandbox]")
        FIRAnalytics.logEvent(withName: "boostsAdded", parameters: ["amount": 100])

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
        //tenBoosts.alpha = 0.0
        //fiftyBoosts.alpha = 0.0
        //hundredBoosts.alpha = 0.0
        
        
        //to interact with side view controller
        
        
        /*
        let initFrame = getBoosts.frame
        tenBoosts.frame = initFrame
        fiftyBoosts.frame = initFrame
        hundredBoosts.frame = initFrame
 */
        
        //productIDs.append("com.Kirin.LiveStream.10Boosts")
        //productIDs.append("com.Kirin.LiveStream.50Boosts")
        //productIDs.append("com.Kirin.LiveStream.100Boosts")
        
        picture = #imageLiteral(resourceName: "avatar")
        
        numVideos.text = "7"
        boostNum.text = "68"
        nameLabel.text = "Molly Bootman"
        profilePic.image = picture
        backgroundImage.image = picture
        
        self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width / 2;
        self.profilePic.clipsToBounds = true;
        
        
        self.profilePic.layer.borderWidth = 2.0;
        self.profilePic.layer.borderColor = UIColor.white.cgColor;
        
        
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

