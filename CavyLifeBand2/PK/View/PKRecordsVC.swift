//
//  PKRecordsVC.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/27.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import RealmSwift

class PKRecordsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: PKRecordsViewModel?
    
    var realm: Realm = try! Realm()
    
    var notificationToken: NotificationToken?
    
    @IBAction func changeData(sender: UIButton) {
        
        self.dataSource?.changeData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Log.info("didLoad")
        // Do any additional setup after loading the view.
        
        tableView.registerNib(UINib.init(nibName: "PKRecordsTableViewCell", bundle: nil), forCellReuseIdentifier: "PKRecordsTableViewCell")
        
        notificationToken = realm.addNotificationBlock { notification, realm in
            self.dataSource?.loadDataFromRealm()
            self.tableView.reloadData()
        }
        
        dataSource = PKRecordsViewModel(realm: realm, tableView: tableView)
        
        dataSource?.loadDataFromRealm()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        Log.info("dealloc")
    }
    
}

extension PKRecordsVC: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (dataSource?.itemGroup.count)!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataSource?.itemGroup[section].count)!
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PKRecordsTableViewCell", forIndexPath: indexPath) as! PKRecordsTableViewCell
        
        cell.textLabel?.text = dataSource?.itemGroup[indexPath.section][indexPath.row].nickName
        
        cell.configure((dataSource?.itemGroup[indexPath.section][indexPath.row])!)
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return dataSource?.canEdit(indexPath.section) ?? false
    }
    
}

extension PKRecordsVC: UITableViewDelegate {
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .Default, title: "删除") {(action, indexPath) in
            Log.info("删除")
            self.dataSource?.deletePKFinish(indexPath)
        }
       
        deleteAction.backgroundColor = UIColor(named: .PKRecordsCellDeleteBtnBGColor)
        
        return [deleteAction]
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 27
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        Log.info(dataSource?.sectionTitle(section) ?? "")
        
        return UIView()
    }

}
