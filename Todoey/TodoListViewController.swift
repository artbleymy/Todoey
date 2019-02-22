//
//  ViewController.swift
//  Todoey
//
//  Created by Stanislav on 22.02.2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//

import UIKit

class TotoListViewController: UITableViewController{

    var itemArray = ["Find Mike", "Buy Eggs", "Destroy Demogorgon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: - Table View Datasource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK: - Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            if cell.accessoryType == UITableViewCell.AccessoryType.none{
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    //MARK - Add new items
    @IBAction func addButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        //add text field
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            
        }
        //add action
        let actionAdd = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //when we add new item
            let newItem = textField.text!
            print("Sucess add \(newItem)")
            if newItem != "" {
                self.itemArray.append(newItem)
            }
            print(self.itemArray)
            self.tableView.reloadData()
            
        }
        
        //cancel action
        alert.addAction(actionAdd)
        let actionCancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
            //when we cancel adding
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(actionCancel)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
}

