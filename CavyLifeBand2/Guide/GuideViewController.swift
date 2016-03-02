//
//  GuideViewController.swift
//  CavyLifeBand2
//
//  Created by 李艳楠 on 16/3/1.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import SnapKit

class GuideViewController: UserSignInBaseViewController {

    var guideBackColor = UIColor(named: .GuideColorBlue)//背景色
    var titleName = String()
    
    @IBOutlet weak var titleLable: UILabel! // 题目
    @IBOutlet weak var infoLabel: UILabel!  // 详情
    @IBOutlet weak var backBtn: UIButton!   // 返回按钮
    @IBOutlet weak var passButton: UIButton! // 跳过按钮
    
    @IBOutlet weak var middleView: UIView!  // 中间底视图
    @IBOutlet weak var subTitle: UILabel!   // 子标题
    @IBOutlet weak var guideButton: UIButton!  // 确定按钮

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = guideBackColor
        
        updateNavigationItemUI(L10n.GuideMyInfo.string, rightBtnText: "")
        
        allViewsLayOut()
        
//        setInfoDetails(L10n.GuideMyInfo.string, info: L10n.GuideIntroduce.string, subName: L10n.GuideMine.string, guideBtnimage: <#T##UIImage#>)
        
        // Do any additional setup after loading the view.
    }
    
    func allViewsLayOut(){
        
        titleLable.textColor = UIColor(named: .GuideColor99)
        titleLable.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(0)
        }
        
        
        infoLabel.textColor = UIColor(named: .GuideColor66)
        infoLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(20)
        }
        backBtn.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(titleLable).offset(spacingWidth25)
        }
        
        passButton.setTitleColor(UIColor(named: .GuideColor66), forState: UIControlState.Normal)
        passButton.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(titleLable).offset(-spacingWidth25)
        }
        
        middleView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(spacingWidth25 * 9 - 66)
        }
        
        subTitle.textColor = UIColor(named: .GuideColor99)
        subTitle.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(middleView).offset(spacingWidth25 * 2)
        }
        
        guideButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(spacingWidth25 * 34 - 66)
        }
        
        self.view.addSubview(guideButton)
    }
    /**
     
     
     - parameter title:         大标题
     - parameter info:          大标题详情
     - parameter subName:       小标题
     - parameter subNameInfo:   小标题详情
     - parameter guideBtnimage: 按钮图标
     */
    func setInfoDetails(title: String, info: String, subName: String, subNameInfo: String, guideBtnimage: UIImage){
        self.title = title
        infoLabel.text = info
        subTitle.text = subName
        guideButton.setImage(guideBtnimage, forState: UIControlState.Normal)
        
    }
    
    @IBAction func backBtnClick(sender: AnyObject) {
        print(__FUNCTION__)
        
        
        
    }
    
    @IBAction func passBtnClick(sender: AnyObject) {
        print(__FUNCTION__)
        
        
        
        
    }
    
    @IBAction func guideBtnClick(sender: AnyObject) {
        
        print(__FUNCTION__)
        
        
        
        
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
