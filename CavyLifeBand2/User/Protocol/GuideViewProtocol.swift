//
//  GuideViewProtocol.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/4/5.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

/**
 *  @author xuemincai
 *
 *  导航页数据协议
 */
protocol GuideViewDataSource {
    
    var title: String { get }
    var subTitle: String { get }
    var bgColor: UIColor { get }
    var centerView: UIView { get }
    var guideBtnImage: UIImage { get }
    var guideBtnHighLightImage: UIImage { get }
    var rightItemBtnTitle: String { get }
    var hiddeGuideBtn: Bool { get }
    var hiddeBackBtn: Bool { get }
    
}

// MARK: - 默认实现
extension GuideViewDataSource {
    
    var subTitle: String { return "" }
    var rightItemBtnTitle: String { return "" }
    var guideBtnImage: UIImage { return UIImage(asset: .GuideRightBtn) }
    var guideBtnHighLightImage: UIImage { return UIImage(asset: .GuideRightBtnHighLight) }
    var bgColor: UIColor { return UIColor(named: .HomeViewMainColor) }
    var hiddeGuideBtn: Bool { return false }
    var hiddeBackBtn: Bool { return false }
    
}

/**
 *  @author xuemincai
 *
 *  导航页代理事件
 */
protocol GuideViewDelegate {
    
    func onClickRight(viewController: UIViewController)
    mutating func onClickGuideOkBtn(viewController: UIViewController)
    func onLoadView()
    func onCilckBack(viewController: UIViewController)
    
}

 extension GuideViewDelegate {
    
    func onClickRight(viewController: UIViewController) {
    }
    
    func onLoadView() {
    }
    
    func onClickGuideOkBtn(viewController: UIViewController) {
    }
    
    func onCilckBack(viewController: UIViewController) {
        
        if viewController.navigationController?.viewControllers.count > 1 {
            
            viewController.popVC()
            
        } else {
            
            viewController.dismissVC(completion: nil)
            
        }
        
    }
    
}
