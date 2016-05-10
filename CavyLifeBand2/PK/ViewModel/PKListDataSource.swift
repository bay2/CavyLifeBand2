//
//  PKListDataSource.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/5/3.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import RealmSwift

protocol PKSectionDataSource {
    
    var sectionTitle: String { get }
    
    var rowCount: Int { get }
    
    var sectionView: UIView? { get }
    
    var sectionHeight: CGFloat { get }
    
    var cellHeight: CGFloat { get }
    
    mutating func loadData()
    
    func createCell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell
    
}

extension PKSectionDataSource {
    
    var sectionView: UIView? {
        
        guard let view = NSBundle.mainBundle().loadNibNamed("PKListSectionView", owner: nil, options: nil).first as? PKListSectionView else {
            Log.error("load Nib(PKListSectionView) error")
            return nil
        }
        
        view.title.text = sectionTitle
        
        return view
    }
    
    var sectionHeight: CGFloat {
        return rowCount <= 0 ? 0 : 28
    }
    
    var cellHeight: CGFloat {
        return 66
    }

    
}

protocol PKListDataSource {
    
    associatedtype ItemType
    
    var item: [ItemType] { get }
    
    mutating func loadData()
    
}

protocol PKListActionDelegate {
    
    func createRowActions(indexPath: NSIndexPath) -> [UITableViewRowAction]?
    var isCanEditRow: Bool { get }
    
}

extension PKListActionDelegate {
    
    func createRowActions(indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        return nil
    }
    
    var isCanEditRow: Bool {
        return false
    }
    
}


typealias PKListDataDelegateProtocols = protocol<PKSectionDataSource, PKRecordsRealmModelOperateDelegate, PKListActionDelegate>
typealias PKListDataProtocols = protocol<PKListDataSource, PKListDataDelegateProtocols>

/**
 *  等待回应数据源
 */
struct PKWaitListDataSource: PKListDataProtocols {
    
    typealias ItemType = PKWaitRecordsCellViewModel
    
    var realm: Realm
    
    var loginUserId: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId
    
    var item: [ItemType] = []
    
    var sectionTitle: String = L10n.PKRecordsVCWaitSectionTitle.string
    
    var rowCount: Int { return item.count }
    
    init(realm: Realm) {
        
        self.realm = realm
        
    }
    
    mutating func loadData() {
        
        let waitDataModel = queryPKWaitRecordsRealm()
        
        item = waitDataModel.map {(waitModel) -> ItemType in
            ItemType(pkRecord: waitModel, realm: realm)
        }
        
    }
    
    func createCell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCellWithIdentifier("ContactsAddFriendCell", forIndexPath: indexPath) as? ContactsAddFriendCell else {
            fatalError()
        }
        
        cell.configure(self.item[indexPath.row], delegate: self.item[indexPath.row])
        
        return cell
        
    }
    
}

/**
 *  PK进行中数据源
 */
struct PKDueListDataSource: PKListDataProtocols {
    
    var realm: Realm
    
    var loginUserId: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId
    
    typealias ItemType = PKDueRecordsCellViewModel
    
    var item: [ItemType] = []
    
    var sectionTitle: String = L10n.PKRecordsVCDueSectionTitle.string
    
    var rowCount: Int { return item.count }
    
    init(realm: Realm) {
        
        self.realm = realm
    }
    
    mutating func loadData() {
        
        let pkDueModel = queryPKDueRecordsRealm()
        
        item = pkDueModel.map {(dueModel) -> ItemType in
            ItemType(pkRecord: dueModel)
        }
        
        
    }
    
    func createCell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCellWithIdentifier("ContactsAddFriendCell", forIndexPath: indexPath) as? ContactsAddFriendCell else {
            fatalError()
        }
        
        cell.configure(self.item[indexPath.row], delegate: self.item[indexPath.row])
        
        return cell
        
    }
    
}

/**
 *  PK完成数据源
 */
struct PKFinishListDataSource: PKListDataProtocols {
    
    var realm: Realm
    
    var loginUserId: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId
    
    typealias ItemType = PKFinishRecordsCellViewModel
    
    var item: [ItemType] = []
    
    var sectionTitle: String = L10n.PKRecordsVCFinishSectionTitle.string
    
    var rowCount: Int { return item.count }
    
    var isCanEditRow: Bool {
        return true
    }
    
    init(realm: Realm) {
        
        self.realm = realm
        
    }
    
    mutating func loadData() {
        
        let pkFinishModel = queryPKFinishRecordsRealm()
        
        item = pkFinishModel.map {(finishModel) -> ItemType in
            ItemType(pkRecord: finishModel, realm: realm)
        }
        
    }
    
    func createCell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCellWithIdentifier("ContactsAddFriendCell", forIndexPath: indexPath) as? ContactsAddFriendCell else {
            fatalError()
        }
        
        cell.configure(self.item[indexPath.row], delegate: self.item[indexPath.row])
        
        return cell
        
    }
    
    func createRowActions(indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let delAction = UITableViewRowAction(style: .Default, title: L10n.ContactsListCellDelete.string) {(_, indexPath) in
            
            self.item[indexPath.row].clickDelete()
            
        }
        
        delAction.backgroundColor = UIColor(named: .ContactsDeleteBtnColor)
        return [delAction]
        
    }
    
}
