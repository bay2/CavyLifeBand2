//
//  HomeStepDetailVC.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/26.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class HomeStepDetailVC: UIViewController, BaseViewControllerPresenter {

    lazy var leftBtn: UIButton? = {
        
        let button = UIButton(type: UIButtonType.Custom)
        button.setBackgroundImage(UIImage(asset: .Backbtn), forState: .Normal)
        
        return button
    }()
    
    lazy var rightBtn: UIButton? = {
        
        let button = UIButton(type: .System)
        button.setTitle("分享", forState: .Normal)
        return button

    }()
    
    var navTitle: String { return "计步" }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        
        
        
        
        
        
        
    }
    
    func onRightBtn() {
         Log.info("分享")
    }
    
}
