//
//  CheckListTableViewController.swift
//  ToDoApp
//
//  Created by A'zamjon Abdumuxtorov on 12/03/24.
//

import UIKit

class CheckListTableViewController: UITableViewController,ItemDetailTableViewControllerDelegate {
    

    var checkList: CheckList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = checkList.name
        
        
//        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @IBAction func addItem(_ sender: Any) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addItemView"{
            let controller = segue.destination as! ItemDetailTableViewController
            controller.delegate = self
        }else if segue.identifier == "editItemView"{
            let controller = segue.destination as! ItemDetailTableViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
                controller.itemToEdit = checkList.items[indexPath.row]
            }
        }
    }
    
    func addItemVCDone(_ vc: ItemDetailTableViewController, didfinishEditing item: CheckListItem) {
        if let index = checkList.items.firstIndex(of: item){
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                configurText(for: cell, with: item)
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    func addItemVCDone(_ vc: ItemDetailTableViewController, didfinishAdding item: CheckListItem) {
        let newRowIndex = checkList.items.count
        
        checkList.items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        
        tableView.insertRows(at: indexPaths, with: .automatic)
     
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "checkListItem", for: indexPath)
        
        let item = checkList.items[indexPath.row]
        configurText(for: cell, with: item)
        configurCheckMark(for: cell, with: item)
    
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkList.items.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath){
            var item = checkList.items[indexPath.row]
            item.checked.toggle()
            configurCheckMark(for: cell, with: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true )
    }
    
    func configurText(for cell: UITableViewCell,with item: CheckListItem){
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    func configurCheckMark(for cell: UITableViewCell,with item: CheckListItem){
        let label = cell.viewWithTag(1001) as! UILabel
        if item.checked{
            label.text = "✔️"
        }else{
            label.text = ""
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        checkList.items.remove(at: indexPath.row)
        
        let indexPath = [indexPath]
        
        tableView.deleteRows(at: indexPath, with: .automatic)
        
    }

}

