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
    
    var cellHeight: CGFloat { get }
    
    var sectionTitle: String { get }
    
}

protocol ContactsCellClickProtocol {
    
    func onClickCell(viewController: UIViewController?, indexPath: NSIndexPath)
    
}


extension ContactsTableViewSectionDataSource {
    
    func createSectionView() -> UIView? {
        return nil
    }
    
    var cellHeight: CGFloat { return 66 }
    
    var sectionTitle: String { return "" }
    
}
