//
//  ViewController.swift
//  Todoey
//
//  Created by Stanislav on 22.02.2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController{

    var itemArray = [Item]()
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }
    
    //MARK: - Table View Datasource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK: - Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done

        tableView.cellForRow(at: indexPath)?.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
        self.saveItems()

        tableView.deselectRow(at: indexPath, animated: true)
//update
//itemArray[indexPath.row].setValue("Completed", forKey: "title")
//delete
//context.delete(itemArray[indexPath.row])
//itemArray.remove(at: indexPath.row)
        
        
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
            let text = textField.text!
            if text != "" {
                let newItem = Item(context: self.context)
                newItem.title = text
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                self.itemArray.append(newItem)
                self.saveItems()
                self.tableView.reloadData()
            }
            
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
    //MARK: - Model manipulation methods
    func saveItems(){
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let basePredicat = request.predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [basePredicat, categoryPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        

        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error during loading data from persistent storage \(error)")
        }
        tableView.reloadData()
    }
    
    
    
}
//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        if searchBar.text?.count > 0{
            let request : NSFetchRequest = Item.fetchRequest()
            
            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            loadItems(with: request)
//        } else {
//            loadItems()
//        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        } else {
            //
        }
    }
}

