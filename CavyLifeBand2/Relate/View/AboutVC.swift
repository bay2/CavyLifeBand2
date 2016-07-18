//
//  AboutVC.swift
//  CavyLifeBand2
//
//  Created by JL on 16/5/6.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class AboutVC: UIViewController, BaseViewControllerPresenter {
    
    var navTitle: String { return L10n.RelateAboutNavTitle.string }

    @IBOutlet weak var copyrightLabel: UILabel!
    
    @IBOutlet weak var useAndPrivateLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    let aboutCellID = "AboutCell"
    
    var tableDataSource: [AboutCellDataSource] = [AboutCellDataSource]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        tableDataSource = [AboutCellModel(title: L10n.RelateAboutCurrentVersion.string, info: ez.appVersion ?? ""),
                           AboutCellModel(title: L10n.RelateAboutFunctionIntroduce.string),
                           AboutCellModel(title: L10n.RelateAboutGoOfficialWebsite.string)]
        
        updateNavUI()
        
        baseUISetting()
        
        addGensture()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func baseUISetting() {
        self.view.backgroundColor = UIColor(named: .HomeViewMainColor)
        
        copyrightLabel.textColor = UIColor(named: .BColor)
        useAndPrivateLabel.textColor = UIColor(named: .CColor)
        
        copyrightLabel.font = UIFont.systemFontOfSize(12.0)
        useAndPrivateLabel.font = UIFont.systemFontOfSize(14.0)
        
        useAndPrivateLabel.text = L10n.RelateAboutUseAndPrivate.string
        copyrightLabel.text = L10n.RelateAboutCopyrightInfo.string
        
        tableView.separatorStyle = .None
        tableView.tableFooterView = UIView()
        tableView.registerNib(UINib.init(nibName: aboutCellID, bundle: nil), forCellReuseIdentifier: aboutCellID)
        tableView.layer.cornerRadius = CavyDefine.commonCornerRadius
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func addGensture() {
        
        useAndPrivateLabel.addTapGesture { [weak self] sender in
            Log.info("前往使用和隐私政策网页")
            
            let targetVC = WebViewController()
            
            targetVC.dataSource = UseAndPrivateWebViewModel()
            
            self?.pushVC(targetVC)
        }
        
        copyrightLabel.addTapGesture { [weak self] sender in
            Log.info("前往版权网页")
            
            let targetVC = WebViewController()
            
            targetVC.dataSource = CopyrightWebViewModel()
            
            self?.pushVC(targetVC)
        }
        
    }
    
}

// MARK: - UITableViewDelegate
extension AboutVC: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let viewFrame = CGRect(x: 0, y: 0, w: tableView.frame.width * 2, h: 10)
        
        let tableFooterView = AboutSectionEmptyView(frame: viewFrame, cornerType: .Bottom)
        
        return tableFooterView
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewFrame = CGRect(x: 0, y: 0, w: tableView.frame.width * 2, h: 10)
        
        let tableHeaderView = AboutSectionEmptyView(frame: viewFrame, cornerType: .Top)
        
        return tableHeaderView
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        if indexPath.row == tableDataSource.count - 1 {
            UIApplication.sharedApplication().openURL(NSURL(string: "http://www.tunshu.com")!)
        }
        
        if tableDataSource[indexPath.row].title == L10n.RelateAboutFunctionIntroduce.string {
            
            self.pushVC(StoryboardScene.Relate.instantiateFunctionIntroduceVC())
        
        }
        
    }
    
}

// MARK: - UITableViewDelegate
extension AboutVC: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(aboutCellID, forIndexPath: indexPath) as? AboutCell
        
        cell?.configure(tableDataSource[indexPath.row])
        
        return cell!
        
    }
    
}

