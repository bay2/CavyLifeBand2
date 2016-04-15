//
//  ContactsTableViewProtocol.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/4/15.
//  Copyright © 2016年 xuemincai. All rights reserved.
//
import UIKit

protocol ContactsAddFriendDataSync {
    
    associatedtype ItemType
    
    var items: [ItemType] { get }
    
    func loadData()
    
}

protocol ContactsTableViewSectionDataSource {
    
    var rowCount: Int { get }
    
    func createCell(cell: ContactsAddFriendCell, index: NSIndexPath) -> ContactsAddFriendCell
    
    func loadData()
    
}
  