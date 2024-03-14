//
//  PickIconViewController.swift
//  ToDoApp
//
//  Created by A'zamjon Abdumuxtorov on 14/03/24.
//

import UIKit

protocol PickIconViewControllerDelegate: AnyObject{
    func iconPicker(_ picker:PickIconViewController, didPick iconName:String)
}

class PickIconViewController: UITableViewController {

    weak var delegate: PickIconViewControllerDelegate!
    
    let icons = ["","alarm","gift","frying.pan","mug","tray","camera","airplane","takeoutbag.and.cup.and.straw","folder"]
    let iconName = ["No icon","Appoinment","Birthday","Chores","Drinks","Inbox","Photos","Trips","Grocies","Folder"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "iconCell", for: indexPath)
        let icon = icons[indexPath.row]
        let iconName = iconName[indexPath.row]
        cell.textLabel?.text = iconName
        cell.imageView?.image = UIImage(systemName: icon)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.iconPicker(self, didPick: icons[indexPath.row])
    }
}
