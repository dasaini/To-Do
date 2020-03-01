//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext



    override func viewDidLoad() {
        super.viewDidLoad()
        
//        loadItems()
        
        self.tableView.reloadData()
    }
    
    // MARK - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title

        print("cellForRowAtIndexPath called")
        // if else substitue for if the item objects method is done method is true then the checkmark is added otherwise if its not true then the checkmark is removed
        itemArray[indexPath.row].done == true ? (cell.accessoryType = .checkmark): (cell.accessoryType = .none)
        // cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none => Another way of doing ternary
        // value = condition ? valueIfTrue : valueIfFalse

        return cell
    }
    
    
    //MARK - Table Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        // if else substitute for if the done property is certain boolean value and is clicked on switch it to the oppposite
        itemArray[indexPath.row].done == false ? (itemArray[indexPath.row].done = true) : (itemArray[indexPath.row].done = false)
        // Allows us to call cellForRowAt again, and change the accessoryType based on the done property of the item cell
        self.saveItem()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    
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
    
    //MARK - Model Manipulation Methods
    
    func saveItem() {
                
        do{
            try context.save()
        }catch{
            print("Error saving context \(error)")
            
        }
        self.tableView.reloadData()
        
    }
    
//    func loadItems(){
//        if let data = try? Data(contentsOf: dataFilePath!){
//            let decoder = PropertyListDecoder()
//            do{
//                itemArray = try decoder.decode([Item].self, from: data)
//            }catch{
//                print("Error decoding item array")
//            }
//
//        }
    }
