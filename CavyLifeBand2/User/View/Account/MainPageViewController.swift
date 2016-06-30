//
//  MainPageViewController.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/4/19.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import SnapKit

class MainPageViewController: UIViewController {
    
    var guidePageDatasources: [GuideIntroduceViewDataSource] = [GuideSafetyDataSource(), GuideRemindDataSource(),
                                                                GuidePKDataSource(), GuideLifeBandDataSource()]
    


    @IBOutlet weak var pageScrollView: UIScrollView!
    
    // 注册按钮
    var signInBtn = MainPageButton()
    
    // 登入按钮
    var signUpBtn = MainPageButton()
    
    // 按钮大小
    var buttonSize: CGSize {
        
        get {
            return CGSize(width: (CavyDefine.spacingWidth25 * 10), height: (CavyDefine.spacingWidth25 * 3))
        }
        
    }
    
    var pageCtrl = CLBPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configScrollView()
        
        configureGuidePageView()
                
        configButton()
        
        configPageCtrl()
        
        self.navBar?.translucent = false
        self.navigationController?.navigationBarHidden = true
        
    }
    
    override func viewWillAppear(animated: Bool) {
        LifeBandBle.shareInterface.stopScaning()
    }
    
    deinit {
        Log.error("deinit MainPageViewController")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /**
     配置滚动视图
     */
    func configScrollView() {
        
        pageScrollView.contentSize = CGSizeMake(ez.screenWidth * CGFloat(guidePageDatasources.count), ez.screenHeight)
        
    }
    
    /**
     配置按钮
     */
    func configButton() {
        
        signInBtn.addTapGesture { _ in
            
            
            self.presentVC(UINavigationController(rootViewController: StoryboardScene.Main.instantiateSignInView()))
            
        }
        
        signUpBtn.addTapGesture { _ in
//            
//            let guideVC = StoryboardScene.Guide.instantiateGuideView()
//            
//            let guideVM = GuideBandBluetooth()
//            guideVC.configView(guideVM, delegate: guideVM)
//            
//            self.presentVC(UINavigationController(rootViewController: guideVC))
//            
            // 注册绑定场景
//            BindBandCtrl.bindScene = .SignUpBind
            
            
            let accountVC = StoryboardScene.Main.instantiateAccountManagerView()
            
            accountVC.configView(PhoneSignUpViewModel())
            
          self.presentVC(UINavigationController(rootViewController: accountVC))
        
        }
        
        signUpBtn.awakeFromNib()
        signInBtn.awakeFromNib()
        
        signInBtn.setTitle(L10n.MainPageSignInBtn.string, forState: .Normal)
        signUpBtn.setTitle(L10n.MainPageSignUpBtn.string, forState: .Normal)
        
        self.view.addSubview(signInBtn)
        self.view.addSubview(signUpBtn)
        
        buttonLayout()
        
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
            make.centerY.equalTo(self.signInBtn.snp_top).offset(-CavyDefine.spacingWidth25 * 2)
            
        }
        
    }
    
    /**
     配置导航背景页面
     */
    func configureGuidePageView() {
        
        for i in 0..<guidePageDatasources.count {
            
            let guide = NSBundle.mainBundle().loadNibNamed("GuideIntroduceView", owner: nil, options: nil).first as! GuideIntroduceView
            
            guide.configure(guidePageDatasources[i])
            
            guide.frame = CGRectMake(CGFloat(i) * ez.screenWidth, 0, ez.screenWidth, ez.screenHeight)
            
            pageScrollView.addSubview(guide)
            
            
        }
        
    }
    
    /**
     按钮布局
     */
    func buttonLayout() {
        
        signUpBtn.snp_makeConstraints { make -> Void in
            
            make.left.equalTo(self.view).offset(CavyDefine.spacingWidth25 * 2)
            make.bottom.equalTo(self.view).offset(-buttonSize.height)
            make.size.equalTo(buttonSize)
            
        }
        
        signInBtn.snp_makeConstraints { make in
            
            make.right.equalTo(self.view).offset(-(CavyDefine.spacingWidth25 * 2))
            make.bottom.equalTo(self.view).offset(-buttonSize.height)
            make.size.equalTo(buttonSize)
            
        }
        
    }
    
    
    /**
     滚动接受
     
     - parameter scrollView:
     */
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        pageCtrl.currentPage = Int(scrollView.contentOffset.x / ez.screenWidth)
        
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
