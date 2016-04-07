//
//  UserSignInBaseViewController.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/2/26.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import SnapKit

class AccountManagerBaseViewController: BaseViewController {


    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(named: .SignInBackground)
        self.automaticallyAdjustsScrollViewInsets = false

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
        
        textFieldView.layer.cornerRadius = CavyDefine.commonCornerRadius
        textFieldView.backgroundColor = UIColor.whiteColor()
        
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
