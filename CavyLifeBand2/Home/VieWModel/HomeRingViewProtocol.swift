//
//  HomeRingViewProtocol.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/12.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

protocol RingViewDataSource {
    
    var image: UIImage { get }
//    var currentLabText: String { get }
//    var percentLabText: String { get }
    var currentNumber: Int { get }
    var targetNumber: Int { get }
    var ringColor: UIColor{ get }
    var diameter: CGFloat { get }
    var ringWidth: CGFloat { get }
}

protocol RingViewDelegate {
    
    func setRingView(view: UIView)
    func setCurrentLabelText() -> NSMutableAttributedString
    func setPercentLabelText() -> String
}

