//
//  ChatSettingsTableViewController.swift
//  EmoChat
//
//  Created by Vladyslav Tsykhmystro on 16.06.17.
//  Copyright © 2017 SoftServe. All rights reserved.
//

import UIKit

class ChatSettingsTableViewController: UITableViewController {
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3 
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        switch section {
            
            case 0: return 1
            
            case 1: return 2
            
            default: return 7
            
        }
    }
    
  /*  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       // var cell = UITableViewCell()
        var logoCell = LogoTableViewCell()
        var usersCell = UserTableViewCell()
        
        if indexPath.section == 0 {
            
           let cell = tableView.dequeueReusableCell(withIdentifier: "logoCell", for: indexPath) as! LogoTableViewCell
            
            cell.conversLogo.image = UIImage.init(named: "1.png")
            //return cell
            
        } else if indexPath.section == 1 && indexPath.row == 0 {
            
             let   cell = tableView.dequeueReusableCell(withIdentifier: "addUser", for: indexPath) as! AddUsersTableViewCell
            
        } else if indexPath.section == 1 && indexPath.row == 1 {
           let cell = tableView.dequeueReusableCell(withIdentifier: "leaveChat", for: indexPath) as! LeaveChatTableViewCell
            
        } else if indexPath.section == 2 {
           let cell = tableView.dequeueReusableCell(withIdentifier: "users", for: indexPath) as! UserTableViewCell
        
        
        return cell
    }
    }
    */
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        switch indexPath.section {
            
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "logoCell", for: indexPath) as! LogoTableViewCell
            cell.conversLogo.image = UIImage.init(named: "1.png")
            cell.conversationTitle.text = "Bolshie molodcy"
            return cell
            
        case 1:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "addUser", for: indexPath) as! AddUserTableViewCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "leaveChat", for: indexPath) as! LeaveChatTableViewCell
                return cell
            }
           
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "user", for: indexPath) as! UserTableViewCell
            return cell
            
        }
    
    }

     // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            
        case 1:
            return "CHAT SETTINGS"
            
        case 2:
            return "7 USERS IN CONVERSATION"
            
        default:
            return ""
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
            
        case 0:
            return 100
            
        case 1:
            return 43
            
        default:
            return 60
        }
        
    }
    
     override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
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



