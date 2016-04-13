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
    var currentLabText: String { get }
    var percentLabText: String { get }
    var currectNumber: Int { get }
    var targetNumber: Int { get }
}

protocol RingViewDelegate {
    
    
    func setCurrentLabelText()
    func setPercentLabelText()
}