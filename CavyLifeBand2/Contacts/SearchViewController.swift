//
//  SearchViewController.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/19.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var phoneSearchBtn = SearchButton()
    var recommendSearchBtn = SearchButton()
    var nearbySearchBtn = SearchButton()
    
    
    
    @IBAction func backActon(sender: AnyObject) {
        self.popVC()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        tableView.registerNib(UINib(nibName: "ContactsSearchTVCell", bundle: nil), forCellReuseIdentifier: "ContactsSearchTVCell")
        
//        addSearchButton()
        
        // Do any additional setup after loading the view.
    }
    
    func requestAction() {
        
        let requestVC = StoryboardScene.Contacts.instantiateRquestView()
        self.pushVC(requestVC)
        
        
    }
    
    /*
    func addSearchButton() {
        
        phoneSearchBtn = SearchButton(frame: CGRectMake(0, 0, ez.screenWidth / 3, 100))
        phoneSearchBtn.initSearchButton(.GuideNotice, name: L10n.ContactsSearchPhoneNum.string)
        recommendSearchBtn = SearchButton(frame: CGRectMake(0, ez.screenWidth / 3, ez.screenWidth / 3, 100))
        recommendSearchBtn.initSearchButton(.GuideNotice, name: L10n.ContactsSearchPhoneNum.string)
        nearbySearchBtn = SearchButton(frame: CGRectMake(0, ez.screenWidth / 3 * 2, ez.screenWidth / 3, 100))
        nearbySearchBtn.initSearchButton(.GuideNotice, name: L10n.ContactsSearchPhoneNum.string)
        
        phoneSearchBtn.selectButtonStatus(.GuideNotice)
        
        self.view.addSubview(phoneSearchBtn)
        self.view.addSubview(recommendSearchBtn)
        self.view.addSubview(nearbySearchBtn)
        
        
    }
    */
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 66
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactsSearchTVCell", forIndexPath: indexPath) as! ContactsSearchTVCell
        
        cell.selectionStyle = .Gray
        
        let viewMode = SearchCellViewModel()
        cell.configure(viewMode, delegate: viewMode)
        cell.requestBtn.addTarget(self, action: "requestAction", forControlEvents: UIControlEvents.TouchUpInside)
        
        let cellBgView = UIView(frame: CGRectMake(0, 0, ez.screenWidth, 66))
        cellBgView.backgroundColor = UIColor(named: .ContactsCellSelect)
        cell.backgroundView = cellBgView
        
        
        
        return cell
    }
    
    // 点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print(__FUNCTION__)
        
        let searchVC = StoryboardScene.Contacts.instantiateSearchView()
        
        self.pushVC(searchVC)
        
        
        
    }
    

    
    /*
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
