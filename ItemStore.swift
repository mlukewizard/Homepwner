//
//  ItemStore.swift
//  Homepwner
//
//  Created by Luke Markham on 18/08/2017.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit

class ItemStore{
    var allItems = [Item]()
    
    init(){
        if let archivedItems = NSKeyedUnarchiver.unarchiveObject(withFile: itemArchiveURL.path) as? [Item]{
            allItems += archivedItems
        }
    }
    
    let itemArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("items.archive")
    }()
    
    func saveChanges() -> Bool {
        print("Saving items to: \(itemArchiveURL.path)")
        return NSKeyedArchiver.archiveRootObject(allItems, toFile: itemArchiveURL.path)
    }
    
    func createItem() -> Item{
        let newItem = Item(random:true)
        allItems.append(newItem)
        return newItem
    }
    
    func removeItem(_ item: Item){
        if let index = allItems.index(of: item){
            allItems.remove(at: index)
        }
    }
    
    func moveItemAtIndex(_ fromIndex: Int, toIndex: Int){
        if fromIndex == toIndex{
            return
        }
        
        //get reference to object being moved so you can reinsert it
        let movedItem = allItems[fromIndex]
        
        //remove item from array
        allItems.remove(at: fromIndex)
        
        //Insert item in array at new location
        allItems.insert(movedItem, at: toIndex)
    }

}

