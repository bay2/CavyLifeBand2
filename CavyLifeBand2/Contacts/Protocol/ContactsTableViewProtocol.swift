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
    
    func createCell(tableview: UITableView, index: NSIndexPath) -> UITableViewCell
    
    func loadData()
    
    func createSectionView() -> UIView?
    
}

extension ContactsTableViewSectionDataSource {
    
    func createSectionView() -> UIView? {
        return nil
    }
    
}
