//
//  GuideViewProtocol.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/4/5.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

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
    var guideBtnImagePress: UIImage { get }
    var rightItemBtnTitle: String { get }
    
}

// MARK: - 默认实现
extension GuideViewDataSource {
    
    var subTitle: String { return "" }
    var rightItemBtnTitle: String { return "" }
    var guideBtnImage: UIImage { return UIImage(asset: .GuideRightBtn) }
    var guideBtnImagePress: UIImage { return UIImage(asset: .GuideRightBtnPressed) }
    
}

/**
 *  @author xuemincai
 *
 *  导航页代理事件
 */
protocol GuideViewDelegate {
    
    func onClickRight(viewController: UIViewController)
    func onClickGuideOkBtn(viewController: UIViewController)
    
}

extension GuideViewDelegate {
    
    func onClickRight(viewController: UIViewController) {}
    
}