//
//  PKListVC.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/5/3.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import RealmSwift

class PKListVC: UIViewController, BaseViewControllerPresenter {

    @IBOutlet weak var pkListTableView: UITableView!
    
    let realm = try! Realm()
    
    private var dataSources: [PKSectionDataSource] = []
    
    var navTitle: String = L10n.PKPKTitle.string
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateNavUI()
        
        pkListTableView.registerNib(UINib(nibName: "ContactsAddFriendCell", bundle: nil), forCellReuseIdentifier: "ContactsAddFriendCell")
        
        addDataSource(PKWaitListDataSource(realm: self.realm, tableView: pkListTableView))
        addDataSource(PKDueListDataSource(realm: self.realm, tableView: pkListTableView))
        addDataSource(PKFinishListDataSource(realm: self.realm, tableView: pkListTableView))
        
        loadItemData()
        
        
        let _ = realm.addNotificationBlock {[unowned self] _, _ in
            self.loadItemData()
        }

    }
    
    deinit {
        
        Log.error("PKListVC deinit")
        
    }
    
    func loadItemData() {
        
        dataSources = dataSources.map {
            var data = $0
            data.loadData()
            return data
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     添加数据源
     
     - parameter dataSource: 数据源
     */
    func addDataSource<T: PKSectionDataSource where T: PKListDataSource>(dataSource: T) {
        
        dataSources.append(dataSource)
        
    }
    
}

// MARK: - TableView
extension PKListVC {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return dataSources[indexPath.section].createCell(tableView, indexPath: indexPath)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSources[section].rowCount
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSources.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return dataSources[indexPath.section].cellHeight
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return dataSources[section].sectionView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return dataSources[section].sectionHeight
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
}
