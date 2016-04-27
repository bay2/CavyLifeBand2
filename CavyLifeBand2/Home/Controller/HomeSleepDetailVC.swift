//
//  HomeSleepDetailVC.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/26.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class HomeSleepDetailVC: UIViewController, BaseViewControllerPresenter {
    
    lazy var leftBtn: UIButton? = {
        
        let leftItemBtn = UIButton(frame: CGRectMake(0, 0, 30, 30))
        leftItemBtn.setBackgroundImage(UIImage(asset: .Backbtn), forState: .Normal)
        return leftItemBtn
        
        
    }()
    
    lazy var rightBtn: UIButton? = {
        
        let button = UIButton(frame: CGRectMake(0, 0, 60, 30))
        button.setTitle("分享", forState: .Normal)
        return button
        
    }()
    
    var navTitle: String = "睡眠" 
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.updateNavUI()
        
        self.view.backgroundColor = UIColor.blueColor()
    }
    
    
    /**
     分享事件
     */
    func onRightBtn() {
        Log.info("分享")
    }
    
}
