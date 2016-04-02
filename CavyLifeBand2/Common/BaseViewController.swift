//
//  BaseViewController.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/3/2.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    let navItemView = UIView()
    let backBtn = UIButton()
    let titleLeb = UILabel()
    let rightBtn = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
 更新NavigationItem UI

 - parameter titleLab:     标题
 - parameter rightBtnText: 右按钮标题
 */
    func updateNavigationItemUI(title: String, rightBtnText: String? = nil, isNeedBack: Bool = true) {

        self.navigationController?.navigationBarHidden = true
        
        self.view.addSubview(navItemView)
        navItemView.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(CavyDefine.spacingWidth25 * 8)
            make.top.right.left.equalTo(self.view)
        }

        titleLeb.text = title
        titleLeb.textColor = UIColor(named: .SignInMainTextColor)
        titleLeb.font = UIFont.systemFontOfSize(22)
        navItemView.addSubview(titleLeb)
        titleLeb.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(navItemView)
            make.centerX.equalTo(navItemView)
        }
        
        if isNeedBack == true {
            
            self.view.addSubview(backBtn)
            backBtn.frame = CGRectMake(0, 0, 30, 30)
            backBtn.setBackgroundImage(UIImage(asset: .Backbtn), forState: .Normal)
            backBtn.addTarget(self, action: #selector(BaseViewController.onClickBack(_:)), forControlEvents: .TouchUpInside)
            navItemView.addSubview(backBtn)
            backBtn.snp_makeConstraints { (make) -> Void in
                make.left.equalTo(CavyDefine.spacingWidth25 * 2)
                make.centerY.equalTo(navItemView)
            }
            
        }

        if let rightText = rightBtnText {
            
            self.view.addSubview(rightBtn)
            rightBtn.setTitle(rightText, forState: .Normal)
            rightBtn.frame = CGRectMake(0, 0, 60, 30)
            rightBtn.setTitleColor(UIColor(named: .SignInMainTextColor), forState: .Normal)
            rightBtn.addTarget(self, action: #selector(BaseViewController.onClickRight(_:)), forControlEvents: .TouchUpInside)
            navItemView.addSubview(rightBtn)
            rightBtn.snp_makeConstraints { (make) -> Void in
                make.right.equalTo(-(CavyDefine.spacingWidth25 * 2))
                make.centerY.equalTo(navItemView)
            }
            
        }

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
