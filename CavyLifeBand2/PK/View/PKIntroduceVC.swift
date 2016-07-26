//
//  PKIntroduceVC.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/19.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class PKIntroduceVC: UIViewController, BaseViewControllerPresenter {
    
    @IBOutlet weak var rulesContainerView: UIView!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var infoImage: UIImageView!
    
    @IBOutlet var introduceInfoView: UIView!
    
    var navTitle: String { return L10n.PKPKTitle.string }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor(named: .HomeViewMainColor)
        
        updateNavUI()
        
        let rulesView = NSBundle.mainBundle().loadNibNamed("PKRulesView", owner: nil, options: nil).first as? PKRulesView
        rulesView?.configure(PKIntroduceVCViewDataSource())
        rulesContainerView.addSubview(rulesView!)
        
        rulesView?.snp_makeConstraints(closure: { (make) in
            make.top.equalTo(rulesContainerView.snp_top)
            make.leading.equalTo(rulesContainerView.snp_leading)
            make.trailing.equalTo(rulesContainerView.snp_trailing)
        })
        
        baseStting()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func baseStting() -> Void {
        
        nextBtn.setImage(UIImage(asset: .PKNextBtnNormal), forState: .Normal)
        nextBtn.setImage(UIImage(asset: .PKNextBtnNormalHighLight), forState: .Highlighted)
        
        titleLabel.text = L10n.PKIntroduceVCInfoTitle.string
        infoLabel.text  = L10n.PKIntroduceVCSelectInfo.string
        
        titleLabel.textColor = UIColor(named: .AColor)
        infoLabel.textColor  = UIColor(named: .GColor)
        
        titleLabel.font = UIFont.systemFontOfSize(14.0)
        infoLabel.font = UIFont.mediumSystemFontOfSize(14.0)
        
        infoImage.image = UIImage.imageWithColor(UIColor.lightGrayColor(), size: infoImage.size)
        
        introduceInfoView.layer.cornerRadius = CavyDefine.commonCornerRadius
    }

    @IBAction func nextAction(sender: UIButton) {
        
        let targetVC = StoryboardScene.PK.instantiatePKInvitationVC()
        self.pushVC(targetVC)
    
    }
    
}
