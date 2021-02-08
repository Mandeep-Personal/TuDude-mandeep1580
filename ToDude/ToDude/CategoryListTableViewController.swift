//
//  CategoryListTableViewController.swift
//  ToDude
//
//  Created by Mandeep Dhillon on 07/02/21.
//

import UIKit
import CoreData
import SwipeCellKit

class CategoryListTableViewController: UITableViewController {
  
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  var categories = [Category]()


  override func viewDidLoad() {
      super.viewDidLoad()
      loadCategories()
      tableView.rowHeight = 80.0
    }
  
  @IBAction func addCategoryButtonTapped(_ sender: UIBarButtonItem) {
    let alertController = UIAlertController(
      title: "Add a new category",
      message: "",
      preferredStyle: .alert
      )
    
    var tempTextField = UITextField()
    
    let alertAction = UIAlertAction(title: "Done", style: .default) { (_) in
      let newCategory = Category(context: self.context)
      if let text = tempTextField.text, text != "" {
        newCategory.name = text
        
        
        self.categories.append(newCategory)
        
        self.saveCategories()
      }
    }
    
    alertController.addTextField { (textField) in
      textField.placeholder = "Category Name"
      tempTextField = textField
    }
    
    alertController.addAction(alertAction)
    
    present(alertController, animated: true, completion: nil)
    
  }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
      return categories.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! SwipeTableViewCell
      
      cell.delegate = self

      cell.textLabel?.text = categories[indexPath.row].name
      
        // Configure the cell...

        return cell
    }
  
  // MARK: - Helper Functions
  
  func saveCategories() {
    do {
      try context.save()
    } catch {
      print ("Error in saving the category!")
    }
    tableView.reloadData()
  }
  
  func loadCategories(){
    let request: NSFetchRequest<Category> = Category.fetchRequest()
   
    do {
      categories = try context.fetch(request)
    } catch {
      print("Error fetching the categories: \(error)")
    }
    tableView.reloadData()
  }
}


extension CategoryListTableViewController: SwipeTableViewCellDelegate {
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    guard orientation == .right else {return nil}
    let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (_, indexPath) in
      self.context.delete(self.categories[indexPath.row])
      self.categories.remove(at: indexPath.row)
      self.saveCategories()
    }
    
    deleteAction.image = UIImage(named: "trash")

    return [deleteAction]
    
  }
  
}
