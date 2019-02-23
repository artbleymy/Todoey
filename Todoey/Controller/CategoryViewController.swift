//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Stanislav on 23.02.2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
    }

     @IBAction func addButtonPresses(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        //add text field
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add New Category"
            textField = alertTextField
        }
        //add action
        let actionAdd = UIAlertAction(title: "Add Category", style: .default) { (action) in
            //when we add new item
            let text = textField.text!
            if text.count > 0 {
                let newCategory = Category(context: self.context)
                newCategory.name = text
                self.categoryArray.append(newCategory)
                self.saveCategories()
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
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "CategoryItemCell")
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
//        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //MARK: - Data manipulation methods
    func saveCategories(){
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error during loading data from persistent storage \(error)")
        }
        tableView.reloadData()
    }
    
}
