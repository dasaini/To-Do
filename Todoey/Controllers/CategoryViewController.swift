//
//  CategoryViewControllerTableViewController.swift
//  Todoey
//
//  Created by Dale Saini on 3/7/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import CoreData


class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    //Analogous to an array
    var categories: Results<Category>?

    @IBOutlet weak var categorySearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categorySearchBar.delegate = self
        loadCategories()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            self.saveCategories(category: newCategory)
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert,animated: true, completion: nil)
        
    }
    
    //MARK: - Data Manipulation with context
    
    func saveCategories(category: Category){
        do{
            try realm.write{
                realm.add(category)
                
            }
        }catch{
            print("Error Saving context: \(error)")
        }
        self.tableView.reloadData()
    }
    
    //Read from Realm Database
    func loadCategories(){
        categories = realm.objects(Category.self)
    }
    
    
    //MARK:- TableView DataSource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
        
    }
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            // the selectedCategory will call the loadItems in the destination controller via didSet
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
}

extension CategoryViewController: UISearchBarDelegate{
    
    
    
}
