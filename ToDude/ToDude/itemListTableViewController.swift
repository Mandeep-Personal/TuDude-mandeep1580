//
//  itemListTableViewController.swift
//  ToDude
//
//  Created by Mandeep Dhillon on 04/02/21.
//

import UIKit
import CoreData

class itemListTableViewController: UITableViewController {

  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items = [Item]()
  
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
      return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
      let item = items[indexPath.row]
      cell.textLabel?.text = item.title
      cell.accessoryType = item.completed ? .checkmark : .none
        return cell
    }

  
  func saveItems() {
    do {
      try context.save()
    } catch {
      print ("Error in saving the items!")
    }
    tableView.reloadData()
  }
}
