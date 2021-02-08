//
//  itemListTableViewController.swift
//  ToDude
//
//  Created by Mandeep Dhillon on 04/02/21.
//

import UIKit
import CoreData
import SwipeCellKit

class itemListTableViewController: UITableViewController {
 
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items = [Item]()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
        loadItems(search: nil)
      tableView.rowHeight = 80.0

    }

  @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
    
    let alertController = UIAlertController(
      title: "Add a new item",
      message: "",
      preferredStyle: .alert
      )
    
    var tempTextField = UITextField()
    
    let alertAction = UIAlertAction(title: "Done", style: .default) { (_) in
      let newItem = Item(context: self.context)
      if let text = tempTextField.text, text != "" {
        newItem.title = text
        newItem.completed = false
        
        self.items.append(newItem)
        
        self.saveItems()
      }
    }
    
    alertController.addTextField { (textField) in
      textField.placeholder = "To Do Title"
      tempTextField = textField
    }
    
    alertController.addAction(alertAction)
    
    present(alertController, animated: true, completion: nil)
    
  }
 
  // MARK: - Table view data source
   
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
      return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self

        // Configure the cell...
      let item = items[indexPath.row]
      cell.textLabel?.text = item.title
      cell.accessoryType = item.completed ? .checkmark : .none
        return cell
    }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    items[indexPath.row].completed = !items[indexPath.row].completed
    saveItems()

  }

  // MARK: - Helper Functions
  
  func saveItems() {
    do {
      try context.save()
    } catch {
      print ("Error in saving the items!")
    }
    tableView.reloadData()
  }
  
  func loadItems(search: String?){
    let request: NSFetchRequest<Item> = Item.fetchRequest()
    
    if let searchText = search {
      let predicate = NSPredicate(format: "title CONTAINS[c] %@", searchText)
      request.predicate = predicate
      let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
      request.sortDescriptors = [sortDescriptor]
    }
   
    do {
      items = try context.fetch(request)
    } catch {
      print("Error fetching the items: \(error)")
    }
    tableView.reloadData()
    
  }
}


extension itemListTableViewController: SwipeTableViewCellDelegate {
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    guard orientation == .right else {return nil}
    let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (_, indexPath) in
      self.context.delete(self.items[indexPath.row])
      self.items.remove(at: indexPath.row)
      self.saveItems()
    }
    
    deleteAction.image = UIImage(named: "trash")

    return [deleteAction]
    
  }
  
}

extension itemListTableViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText.count > 0 {
      loadItems(search: searchText)
    }
    else if searchText.count == 0 {
      loadItems(search: nil)
    }
  }
  }
