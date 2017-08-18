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
    
    func createItem() -> Item{
        let newItem = Item(random:true)
        allItems.append(newItem)
        return newItem
    }
    
    init(){
        for _ in 0..<5{
            createItem()
        }
    }
}

