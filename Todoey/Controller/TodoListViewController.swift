//
//  ViewController.swift
//  Todoey
//
//  Created by Stanislav on 22.02.2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController{

    
    @IBOutlet weak var searchBar: UISearchBar!
    let realm = try! Realm()
    var todoItems: Results<Item>?
    
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory!.name
//        use guard instead of if let
        guard let colourHex = selectedCategory?.colour else {fatalError()}
        updateNavBar(withHexCode: colourHex)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        updateNavBar(withHexCode: "1D9BF6")
        
    }
    
    //MARK: - Navigation Bar Setup Methods
    
    func updateNavBar(withHexCode colourHexCode: String)  {
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist")}
        guard let colour = UIColor(hexString: colourHexCode) else { fatalError() }
        navBar.barTintColor = colour
        navBar.tintColor = UIColor(contrastingBlackOrWhiteColorOn: colour, isFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(contrastingBlackOrWhiteColorOn: colour, isFlat: true)]
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = colour.cgColor
        searchBar.barTintColor = colour
    }
    
    
    //MARK: - Table View Datasource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            if let colour = UIColor(hexString: selectedCategory!.colour).darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)){
                cell.backgroundColor = colour
                cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: colour, isFlat: true)
            }
            
        } else {
            cell.textLabel?.text = "No items in category"
        }
        
        return cell
    }
    
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    //MARK: - Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
//                    realm.delete(item)
                    item.done = !item.done
                    tableView.cellForRow(at: indexPath)?.accessoryType = item.done ? .checkmark : .none
                }
            } catch {
                    print("Error saving item")
            }
        }

        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //в этом месте удаление сделано без использований сторонних cocoapods
    //deleting without third-party cocoapods
//    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        ///remove anything
//        let remove = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
//            if let item = self.todoItems?[indexPath.row] {
//                do {
//                    try self.realm.write {
//                        self.realm.delete(item)
//                        self.loadItems()
//                    }
//                } catch {
//                    print("Error deleting item \(error)")
//                }
//            }
//        }
//        return [remove]
//    }
    
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
                if let currentCategory = self.selectedCategory{
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = text
                            newItem.dateCreate = Date()
                            currentCategory.items.append(newItem)
                        }
                    } catch {
                        print("Error when save new item \(error)")
                    }
                    
                }
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
    
    func loadItems(){
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreate", ascending: false)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        
        super.updateModel(at: indexPath)
        
        if let item = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(item)
                }
            } catch {
                print("Error deleting item \(error)")
            }
        }
        
    }
    
    
}

//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text!
        if text.count > 0{
            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreate", ascending: false)
            tableView.reloadData()
        } else {
            loadItems()
        }
        
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
//        filterItems(for: searchBar.text!)
        if searchText.count == 0 {
            loadItems()
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
//    func filterItems(for text: String){
//
//        if text.count == 0 {
//            loadItems()
//            tableView.reloadData()
//        }
//
//        tableView.reloadData()
//    }
    
    
}

