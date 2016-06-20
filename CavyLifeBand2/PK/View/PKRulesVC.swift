//
//  PKRulesVC.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/19.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class PKRulesVC: UIViewController, BaseViewControllerPresenter {

    let rulesViewMargin: CGFloat = 20.0
    
    var navTitle: String { return L10n.PKPKTitle.string }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.edgesForExtendedLayout = .None
        self.automaticallyAdjustsScrollViewInsets = false
        
        updateNavUI()
        
        let rulesView = NSBundle.mainBundle().loadNibNamed("PKRulesView", owner: nil, options: nil).first as? PKRulesView
        rulesView?.configure(PKRulesVCViewDataSource())
        self.view.addSubview(rulesView!)
        
        rulesView?.snp_makeConstraints(closure: { (make) in
            make.top.equalTo(self.view.snp_top).offset(30)
            make.leading.equalTo(self.view.snp_leading).offset(rulesViewMargin)
            make.trailing.equalTo(self.view.snp_trailing).offset(-rulesViewMargin)
        })
        
        
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
