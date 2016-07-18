//
//  FunctionIntroduceVC.swift
//  CavyLifeBand2
//
//  Created by JL on 16/6/30.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class FunctionIntroduceVC: UIViewController, BaseViewControllerPresenter {

    @IBOutlet weak var scrollView: UIScrollView!

    var navTitle: String { return L10n.RelateAboutFunctionIntroduce.string }
    
    var guidePageDatasources: [GuideIntroduceViewDataSource] = [GuideSafetyDataSource(), GuideRemindDataSource(),
                                                                GuidePKDataSource(), GuideLifeBandDataSource()]
    var pageCtrl = CLBPageControl()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.view.backgroundColor = UIColor(named: .HomeViewMainColor)
        
        updateNavUI()
        
        configScrollView()
        
        configureGuidePageView()
        
        configPageCtrl()
        
    }

}

extension FunctionIntroduceVC {

    /**
     配置滚动视图
     */
    func configScrollView() {
        
        scrollView.contentSize = CGSizeMake(ez.screenWidth * CGFloat(guidePageDatasources.count), ez.screenHeight - 64)
        
    }
    
    /**
     配置 page 控制器
     */
    func configPageCtrl() {
        
        pageCtrl.currentPage = 0
        pageCtrl.numberOfPages = guidePageDatasources.count
        
        self.view.addSubview(pageCtrl)
        
        pageCtrl.snp_makeConstraints { make in
            
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-CavyDefine.spacingWidth25 * 3)
            
        }
        
    }
    
    /**
     配置导航背景页面
     */
    func configureGuidePageView() {
        
        for i in 0..<guidePageDatasources.count {
            
            let guide = NSBundle.mainBundle().loadNibNamed("GuideIntroduceView", owner: nil, options: nil).first as! GuideIntroduceView
            
            guide.configure(guidePageDatasources[i])
            
            guide.frame = CGRectMake(CGFloat(i) * ez.screenWidth, 0, ez.screenWidth, ez.screenHeight - 64)
            
            scrollView.addSubview(guide)
            
            
        }
        
    }
    
}


extension FunctionIntroduceVC: UIScrollViewDelegate {

    /**
     滚动接受
     
     - parameter scrollView:
     */
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        pageCtrl.currentPage = Int(scrollView.contentOffset.x / ez.screenWidth)
        
    }

}