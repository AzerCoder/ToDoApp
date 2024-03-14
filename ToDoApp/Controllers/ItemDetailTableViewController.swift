//
//  AddItemTableViewController.swift
//  ToDoApp
//
//  Created by A'zamjon Abdumuxtorov on 13/03/24.
//

import UIKit


protocol ItemDetailTableViewControllerDelegate: AnyObject{
    func addItemVCDone(_ vc: ItemDetailTableViewController,didfinishAdding item: CheckListItem)
    func addItemVCDone(_ vc: ItemDetailTableViewController,didfinishEditing item: CheckListItem)
}

class ItemDetailTableViewController: UITableViewController {

    @IBOutlet weak var addItemTF: UITextField!
    @IBOutlet weak var doneBarItem: UIBarButtonItem!
    @IBOutlet weak var remindSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    weak var delegate : ItemDetailTableViewControllerDelegate?
    var itemToEdit : CheckListItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneBarItem.isEnabled = false
        addItemTF.delegate = self
       
        if let itemToEdit = itemToEdit{
            title = "Edit Item"
            addItemTF.text = itemToEdit.text
            doneBarItem.isEnabled = true
            remindSwitch.isOn = itemToEdit.shouldRemind
            datePicker.date = itemToEdit.dueDate
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addItemTF.becomeFirstResponder()
    }

    @IBAction func remindTogled(_ sender: UISwitch) {
        addItemTF.resignFirstResponder()
        
        if sender.isOn{
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert,.sound]) { _, _ in
                
            }
        }
    }
    @IBAction func doneBar(_ sender: Any) {
        
        if let itemToEdit = itemToEdit{
            itemToEdit.text = addItemTF.text!
            itemToEdit.shouldRemind = remindSwitch.isOn
            itemToEdit.dueDate = datePicker.date
            itemToEdit.scheduleNotification()
            delegate?.addItemVCDone(self, didfinishEditing: itemToEdit)
            
        }else{
            let item = CheckListItem()
            item.text = addItemTF.text!
            item.checked = false
            
            item.shouldRemind = remindSwitch.isOn
            item.dueDate = datePicker.date
            item.scheduleNotification()
            delegate?.addItemVCDone(self, didfinishAdding: item)
        }
    }
    

}

extension ItemDetailTableViewController: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        
        let stringRange = Range(range, in: oldText)!
        
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        
        if newText.isEmpty{
            doneBarItem.isEnabled = false
        }else{
            doneBarItem.isEnabled = true
        }
        
        return true
    }
}
