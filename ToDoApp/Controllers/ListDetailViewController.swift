//
//  ListDetailViewController.swift
//  ToDoApp
//
//  Created by A'zamjon Abdumuxtorov on 13/03/24.
//

import UIKit

protocol ListDetailViewControllerDelegate: AnyObject{
    func listDetailVCDone(_ vc: ListDetailViewController,didfinishAdding item: CheckList)
    func listDetailVCDone(_ vc: ListDetailViewController,didfinishEditing item: CheckList)
}

class ListDetailViewController: UITableViewController {

    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var iconImage: UIImageView!
    
    weak var delegate : ListDetailViewControllerDelegate?
    var itemToEdit : CheckList?
    var iconName : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textField.delegate = self
        doneButton.isEnabled = false
       
        if let itemToEdit = itemToEdit{
            title = "Edit Item"
            textField.text = itemToEdit.name
            doneButton.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showIcon"{
            let vc = segue.destination as! PickIconViewController
            vc.delegate = self
        }
    }

    @IBAction func doneButton(_ sender: UIBarButtonItem) {
        
        if let itemToEdit = itemToEdit{
            itemToEdit.name = textField.text!
            itemToEdit.iconName = iconName
            delegate?.listDetailVCDone(self, didfinishEditing: itemToEdit)
            
        }else{
            let item = CheckList(name: textField.text!,iconName: iconName)
            delegate?.listDetailVCDone(self, didfinishAdding: item)
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath.section == 1 ? indexPath: nil 
    }
    
    
}

extension ListDetailViewController: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        
        let stringRange = Range(range, in: oldText)!
        
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        
        if newText.isEmpty{
            doneButton.isEnabled = false
        }else{
            doneButton.isEnabled = true
        }
        
        return true
    }
}

extension ListDetailViewController:PickIconViewControllerDelegate{
    
    func iconPicker(_ picker: PickIconViewController, didPick iconName: String) {
        self.iconName = iconName
        iconImage.image = UIImage(systemName: iconName)
        navigationController?.popViewController(animated: true)
    }
    
    
}
