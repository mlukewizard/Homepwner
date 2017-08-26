//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by Luke Markham on 18/08/2017.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController{
    
    var itemStore : ItemStore!
    var imageStore: ImageStore!
    
    @IBAction func addNewItem(_ sender: AnyObject){
        //Create a new item and add it to the store
        let newItem = itemStore.createItem()
        
        //figure out where that item is in the array
        if let index = itemStore.allItems.index(of: newItem){
            let indexPath = IndexPath(row: index, section: 0)
            
            //Insert this new row into the table
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    //page 219
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func tableView(_ tableView: UITableView,
        moveRowAt sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath){
            //update the model
            itemStore.moveItemAtIndex(sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }

    
    override func tableView(_ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return itemStore.allItems.count
    }
    
    override func tableView(_ tableView: UITableView,
        commit editingStyle: UITableViewCellEditingStyle,
        forRowAt indexPath: IndexPath){
            
            //if the table view is asking to commit a delete command...
            if editingStyle == .delete{
                let item = itemStore.allItems[indexPath.row]
                
                let title = "Delete \(item.name)?"
                let message = "Are you sure you want to delete this item?"
                
                let ac = UIAlertController(title: title,
                    message: message,
                    preferredStyle: .actionSheet)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                ac.addAction(cancelAction)
                
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive,
                    handler: {(action) -> Void in
                        
                        //Remove the item from the store
                        self.itemStore.removeItem(item)
                        
                        //Remove the items image from the image store
                        self.imageStore.deleteImageForKey(item.itemKey)
                        
                        //Also remove the that row from the table view with an animation
                        self.tableView.deleteRows(at: [indexPath], with: .automatic)
                })
                ac.addAction(deleteAction)
                
                //present the alert controller
                present(ac, animated: true, completion: nil)
            }
            
    }
    
    //page 200
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //If the triggered segue is the ShowItem segue
        if segue.identifier == "ShowItem" {
            //Figure out which row was just tapped
            if let row = tableView.indexPathForSelectedRow?.row{
                
                //Get the item associated with this row and pass it along
                let item = itemStore.allItems[row]
                let detailViewController =
                    segue.destination as! DetailViewController
                detailViewController.item = item
                detailViewController.imageStore = imageStore
            }
        }
    }
            
    override func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            //Create an instance of UITableViewCell, with default appearance
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell",
                for: indexPath) as! ItemCell
            
            //Set the text on the cell with the description of the item
            //that is at the nth index of items, where n= row this cell
            //will appear in on the tableview
            let item = itemStore.allItems[indexPath.row]
            
            cell.nameLabel.text = item.name
            cell.serialNumberLabel.text = item.serialNumber
            cell.valueLabel.text = "$\(item.valueInDollars)"
            
            return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
    }
}
