//
//  HomeListProtocol.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/5/24.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

// HomeListViewModelProtocol
protocol HomeListViewModelProtocol {
    
    var image: UIImage { get }
    var title: String { get }
    var friendName: String { get }
    var friendIconUrl: String { get }
    var resultNum: NSMutableAttributedString { get }
    
    func onClickCell()
        
}


