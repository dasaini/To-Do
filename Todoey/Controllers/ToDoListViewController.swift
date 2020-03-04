//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData


class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    



    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        loadItems()
        
        self.tableView.reloadData()
    }
    
    // MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title

        // if else substitue for if the item objects method is done method is true then the checkmark is added otherwise if its not true then the checkmark is removed
        itemArray[indexPath.row].done == true ? (cell.accessoryType = .checkmark): (cell.accessoryType = .none)
        // cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none => Another way of doing ternary
        // value = condition ? valueIfTrue : valueIfFalse

        return cell
    }
    
    
    //MARK: - Table Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //deleting an item
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        
        
        
        // if else substitute for if the done property is certain boolean value and is clicked on switch it to the oppposite
        itemArray[indexPath.row].done == false ? (itemArray[indexPath.row].done = true) : (itemArray[indexPath.row].done = false)
        
        
        self.saveItem()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        // this handler gets triggered everytime someone clicks on the action
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            
            self.saveItem()
            
            self.tableView.reloadData()
        }
        
        // this handler only gets triggered when the textfield gets added to the alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
         
    }
    
    //MARK: - Model Manipulation Methods
    
    func saveItem() {
                
        do{
            try context.save()
        }catch{
            print("Error saving context \(error)")
            
        }
        self.tableView.reloadData()
        
    }
    
    // Using read in a SQLite database
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()){
        do{
           itemArray = try context.fetch(request)
        }catch{
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
     }
    
    

}

// MARK: - Search Bar Methods
extension ToDoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // customizing the requet
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        
        
        // fetching the request using context
        
        loadItems(with: request)
        
        
//        do{
//            // assigning the requst to our itemArray
//           itemArray = try context.fetch(request)
//        }catch{
//            print("Error fetching data from context \(error)")
//        }
        
        tableView.reloadData()
        
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar.text?.count == 0){
            loadItems()
        }
        
    }
    
    
    
}
