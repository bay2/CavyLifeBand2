//
//  ContactsFriendInfoVC.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/22.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import Log

class ContactsFriendInfoVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var contectView: UIView!
    
    @IBOutlet weak var infoTableView: UITableView!
    
    @IBOutlet weak var qualityTableView: UITableView!
    
    // TableView Identifier
    let infoHeadIdentifier = "FriendInfoHeadIdentifier"
    let infoBodyIdentifier = "FriendInfoBodyIdentifier"
    let infoWhiteIdentifier = "FriendInfoWhiteIdentifier"
    let qualityIdentifier = "FriendQualityIdentifier"
    let qualityWhiteIdentifier = "FriendQualityWhiteIdentifier"
    
    var infoCellCount: Int = 8    // cell个数 八个为身高体重年龄全部可见
    let infoTitleArray = [L10n.ContactsShowInfoTransformNotes.string, L10n.ContactsShowInfoNotesName.string, L10n.ContactsShowInfoCity.string, L10n.ContactsShowInfoOld.string, L10n.ContactsShowInfoGender.string, L10n.ContactsShowInfoHeight.string, L10n.ContactsShowInfoWeight.string, L10n.ContactsShowInfoBirth.string]
    let qualityTitleArray = [L10n.ContactsShowInfoPK.string, L10n.ContactsShowInfoStep.string, L10n.ContactsShowInfoSleep.string]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()        
        self.view.backgroundColor = UIColor(named: .HomeViewMainColor)
        
        addAllViews()
        
    }
    
    /**
     添加 全部视图
     */
    func addAllViews() {
        
        // InfoTableView高度
        // |-infoListCell-136-|-cellCount-1[infoListCell] * 50-|-边10-|
        let tableViewHeight = CGFloat(136 + (infoCellCount - 1) * 50 + 10)
        
        // contentView 
        contectView.backgroundColor = UIColor(named: .HomeViewMainColor)
        contectView.snp_makeConstraints { (make) in
            // |-16-|-infoTableView-|-10-|-qualityTableView-170-|-20-|
            make.height.equalTo(tableViewHeight + 216)
        }
        
        infoTableView.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(tableViewHeight)
        }
        tableViewBaseSetting(infoTableView)
        infoTableView.registerNib(UINib(nibName: "ContactsPersonInfoCell", bundle: nil), forCellReuseIdentifier: infoHeadIdentifier)
        infoTableView.registerNib(UINib(nibName: "ContactsPersonInfoListCell", bundle: nil), forCellReuseIdentifier: infoBodyIdentifier)
        
        // qualityTableView
        tableViewBaseSetting(qualityTableView)
        qualityTableView.registerNib(UINib(nibName: "ContactsFriendQualityCell", bundle: nil), forCellReuseIdentifier: qualityIdentifier)
        
    }
    
    /**
     tableView的基本设置
     */
    func tableViewBaseSetting(tableView: UITableView) {
        
        tableView.layer.cornerRadius = CavyDefine.commonCornerRadius
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.separatorStyle = .None
        tableView.showsVerticalScrollIndicator = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Tableview Delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.isEqual(infoTableView) {
            
            return infoCellCount + 1
            
        } else {
            
            return 5
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if tableView.isEqual(infoTableView) {
            
            if indexPath.row == 0 {
                
                return 136
                
            } else if indexPath.row == infoCellCount {
                
                return 10
                
            }
            
            return 50
            
        } else {
            
            if indexPath.row == 0 || indexPath.row == 4 {
                
                return 10
            }
            
            return 50
            
        }
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView.isEqual(infoTableView) {
            
            if indexPath.row == 0 {
                
                // 个人信息
                let cell = tableView.dequeueReusableCellWithIdentifier(infoHeadIdentifier, forIndexPath: indexPath) as! ContactsPersonInfoCell
                cell.personRealtion(.FriendRelation)
                return cell
                
            } else if indexPath.row == infoCellCount {
                
                // 最下面边空白
                tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: infoWhiteIdentifier)
                let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(infoWhiteIdentifier)!
                return cell
                
            }
            
            // 其他数值
            let cell = tableView.dequeueReusableCellWithIdentifier(infoBodyIdentifier, forIndexPath: indexPath) as! ContactsPersonInfoListCell
            
            if indexPath.row == 1 {
                
                cell.addData(infoTitleArray[indexPath.row], titleInfo: infoTitleArray[0], cellEditOrNot: true)
                
            } else {
                
                cell.addData(infoTitleArray[indexPath.row], titleInfo: "160", cellEditOrNot: false)
                
            }
            return cell
            
        } else {
            
            if indexPath.row == 0 || indexPath.row == 4 {
                
                tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: qualityWhiteIdentifier)
                let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(qualityWhiteIdentifier)!
                cell.backgroundColor = UIColor.whiteColor()
                return cell
                
            }
            
            let cell = tableView.dequeueReusableCellWithIdentifier(qualityIdentifier, forIndexPath: indexPath) as! ContactsFriendQualityCell
            if indexPath.row == 1 {
                cell.cellEditOrNot = true
            }
            return cell
 
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView.isEqual(infoTableView) && indexPath.row == 1 {

            // 跳转到修改备注
            let requestVC = StoryboardScene.Contacts.instantiateContactsReqFriendVC()
            requestVC.requestStyle = .ChangeNotesName
            self.pushVC(requestVC)
            
        }
        
        if tableView.isEqual(qualityTableView) && indexPath.row == 0 {
    
            Log.info("PK页面")
            
        }
        
    }
    

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
