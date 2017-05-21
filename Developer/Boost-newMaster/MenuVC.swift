//
//  MenuVC.swift
//  
//
//  Created by Kirin Sinha Prior on 4/30/17.
//
//

import Foundation

class MenuVC: UITableViewController {
    
    var MenuArray = [String]()
    
    
    override func viewDidLoad() {
        //create structure for displaying the right text / image in the search bar menu
        MenuArray = ["MY ACCOUNT","GO LIVE", "WATCH", "LOGOUT"]

    }
    
    //set up filtering capacity for search bar when the search bar is active
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuArray[indexPath.row], for: indexPath) as UITableViewCell
            cell.textLabel?.text = MenuArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            return MenuArray.count
        
    }
    
}
