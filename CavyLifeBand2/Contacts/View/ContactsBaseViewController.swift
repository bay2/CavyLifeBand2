//
//  ContactsBaseViewController.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/3/19.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class ContactsBaseViewController: UIViewController {

    override func viewDidLoad() {

        super.viewDidLoad()

        configNavItem()

        configNavBar()

    }

    /**
     配置Item
     */
    func configNavItem() {

        let backBtn = UIButton(type: .System)
        backBtn.addTarget(self, action: #selector(ContactsBaseViewController.onClickBack), forControlEvents: .TouchUpInside)

        backBtn.setBackgroundImage(UIImage(asset: .Backbtn), forState: .Normal)

        backBtn.frame = CGRectMake(0, 0, 30, 30)
        let backButtonItem = UIBarButtonItem(customView: backBtn)
        let spacingBtnItem = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        spacingBtnItem.width = 14

        self.navigationItem.leftBarButtonItems = [spacingBtnItem, backButtonItem]

    }

    /**
     配置bar
     */
    func configNavBar() {

        self.navBar?.shadowImage = UIImage.imageWithColor(UIColor(named: .HomeViewMainColor), size: CGSizeMake(ez.screenWidth, 1))
        self.navBar?.setBackgroundImage(UIImage.imageWithColor(UIColor(named: .HomeViewMainColor), size: CGSizeMake(ez.screenWidth, 64)), forBarPosition: .Any, barMetrics: .Default)

        let titleLable = UILabel(frame: CGRectMake(0, 0, 60, 44))
        titleLable.text = L10n.ContactsTitle.string
        titleLable.textColor = UIColor(named: .ContactsTitleColor)
        titleLable.font = UIFont.systemFontOfSize(18)

        self.navigationItem.titleView = titleLable
    }

    func onClickBack() {

        self.popVC()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
