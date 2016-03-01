//
//  UserSignInBaseViewController.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/2/26.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class UserSignInBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     更新输入框背景视图UI
     
     - parameter textFieldView:
     */
    func updateTextFieldViewUI(textFieldView: UIView) {
        
        textFieldView.layer.cornerRadius = commonCornerRadius
        textFieldView.backgroundColor = UIColor.whiteColor()
        
    }


    /**
     更新NavigationItem UI
     
     - parameter titleLab:     标题
     - parameter rightBtnText: 右按钮标题
     */
    func updateNavigationItemUI(title: String, rightBtnText: String) {

        self.view.backgroundColor = UIColor(named: .SignInBackground)
        self.navigationController?.navigationBar.barTintColor = UIColor(named: .SignInNavigationBar)
        self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(UIColor(named: .SignInNavigationBar), size: CGSizeMake(ez.screenWidth, 1))
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(UIColor(named: .SignInNavigationBar), size: CGSizeMake(ez.screenWidth, 64)), forBarPosition: .Any, barMetrics: .Default)

        let titleLeb = UILabel()

        titleLeb.text = title
        titleLeb.textColor = UIColor(named: .SignInMainTextColor)
        titleLeb.font = UIFont.systemFontOfSize(22)
        titleLeb.frame = CGRectMake(0, 0, 60, 30)

        self.navigationItem.titleView = titleLeb

        let backBtn = UIButton()
        backBtn.frame = CGRectMake(0, 0, 30, 30)
        backBtn.setBackgroundImage(UIImage(asset: .Backbtn), forState: .Normal)
        backBtn.addTarget(self, action: "onClickBack:", forControlEvents: .TouchUpInside)
        let backBackItem = UIBarButtonItem(customView: backBtn)
        
        let rightBtn = UIButton()
        rightBtn.setTitle(rightBtnText, forState: .Normal)
        rightBtn.frame = CGRectMake(0, 0, 60, 30)
        rightBtn.setTitleColor(UIColor(named: .SignInMainTextColor), forState: .Normal)

        rightBtn.addTarget(self, action: "onClickRight:", forControlEvents: .TouchUpInside)
        let rightItem = UIBarButtonItem(customView: rightBtn)

        self.navigationItem.leftBarButtonItems = [backBackItem]
        self.navigationItem.rightBarButtonItems = [rightItem]
        
    }
    
    /**
     返回按钮点击事件
     
     - parameter sender:
     */
    func onClickBack(sender: AnyObject) {

        self.popVC()
        dismissVC(completion: nil)

    }
    
    /**
     右侧按钮点击事件
     
     - parameter sender:
     */
    func onClickRight(sender: AnyObject) {
        
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
