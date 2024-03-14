//
//  AllListViewController.swift
//  ToDoApp
//
//  Created by A'zamjon Abdumuxtorov on 13/03/24.
//

import UIKit

class AllListViewController: UITableViewController {
    
    var list = [CheckList]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCheckListItems()
        title = "Check List"
        
//        let one = CheckList(name: "Homework")
//        let two = CheckList(name: "Birthday")
//        let three = CheckList(name: "Homeduty")
//        
//        list.append(one)
//        list.append(two)
//        list.append(three)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCheckList"{
            let controller = segue.destination as! CheckListTableViewController
            controller.checkList = sender as? CheckList
        }else if segue.identifier == "showAddList"{
            
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
            
//            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
//                controller.itemToEdit = list[indexPath.row]
//            }
        }
    }
    
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "checkListCell", for: indexPath)
        
        let checkItem = list[indexPath.row]
        
        cell.textLabel?.text = checkItem.name
        cell.detailTextLabel?.text = "\(checkItem.countUncheckedItems())"
        cell.accessoryType = .detailDisclosureButton
        cell.imageView?.image = UIImage(systemName: checkItem.iconName)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let checkList = list[indexPath.row]
        
        performSegue(withIdentifier: "showCheckList", sender: checkList)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(identifier: "ListDetailViewController") as! ListDetailViewController
        controller.delegate = self
        let checkList = list[indexPath.row]
        controller.itemToEdit = checkList
        
        navigationController?.pushViewController(controller, animated: true)
    }

}

extension AllListViewController:ListDetailViewControllerDelegate{
    
    func listDetailVCDone(_ vc: ListDetailViewController, didfinishAdding item: CheckList) {
        let newRowIndex = list.count
        
        list.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        
        tableView.insertRows(at: indexPaths, with: .automatic)
//        saveCheckListItems()
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailVCDone(_ vc: ListDetailViewController, didfinishEditing item: CheckList) {
        if let index = list.firstIndex(of: item){
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                cell.textLabel?.text = item.name
            }
        }
//        saveCheckListItems()
        navigationController?.popViewController(animated: true)
    }
    
    
}

extension AllListViewController{
    
    func documentDirectory()->URL?{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths.first
    }
    
    func dataFilePath()->URL{
        return documentDirectory()!.appendingPathComponent("CheckList.plist")
    }
    
    func saveCheckListItems(){
        let encoder = PropertyListEncoder()
        
        do {
            let data = try! encoder.encode(list)
            try data.write(to: dataFilePath(),options: Data.WritingOptions.atomic)
        } catch{
            print("\(error.localizedDescription)")
        }
    }
    
    func loadCheckListItems(){
        let paths = dataFilePath()
        
        if let data = try? Data(contentsOf: paths){
            let decoder = PropertyListDecoder()
            
            do{
                list = try decoder.decode([CheckList].self, from: data)
            } catch{
                print("\(error.localizedDescription)")
            }
        }
    }
}
