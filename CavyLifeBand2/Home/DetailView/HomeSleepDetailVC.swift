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
        
        let button = UIButton(type: .System)
        button.setBackgroundImage(UIImage(asset: .Backbtn), forState: .Normal)
        return button
        
    }()
    
    lazy var rightBtn: UIButton? = {
        
        let button = UIButton(type: .System)
        button.setTitle("分享", forState: .Normal)
        return button
        
    }()
    
    var navTitle: String { return "睡眠" }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        self.view.backgroundColor = UIColor.blueColor()
    }
    
    
    /**
     分享事件
     */
    func onRightBtn() {
        Log.info("分享")
    }
    
}
