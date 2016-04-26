//
//  ContactsAddFriendVC_ExtDataSource.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/4/17.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation

extension ContactsAddressBookFriendData: ContactsTableViewSectionDataSource {
    
    var rowCount: Int {
        return items.count
    }
    
    func createCell(cell: ContactsAddFriendCell, index: NSIndexPath) -> ContactsAddFriendCell {
        
        cell.configure(items[index.row], delegate: items[index.row])
        
        return cell
        
    }
    
}

extension ContactsRecommendFriendData: ContactsTableViewSectionDataSource {
    
    var rowCount: Int {
        return items.count
    }
    
    func createCell(cell: ContactsAddFriendCell, index: NSIndexPath) -> ContactsAddFriendCell {
        
        cell.configure(items[index.row], delegate: items[index.row])
        
        return cell
        
    }
    
}

extension ContactsSearchFriendData: ContactsTableViewSectionDataSource {
    
    var rowCount: Int {
        return items.count
    }
    
    func createCell(cell: ContactsAddFriendCell, index: NSIndexPath) -> ContactsAddFriendCell {
        cell.configure(items[index.row], delegate: items[index.row])
        return cell
    }
    
}

extension ContactsNearbyFriendData: ContactsTableViewSectionDataSource {
    
    var rowCount: Int {
        return items.count
    }
    
    func createCell(cell: ContactsAddFriendCell, index: NSIndexPath) -> ContactsAddFriendCell {
        cell.configure(items[index.row], delegate: items[index.row])
        return cell
    }
    
}