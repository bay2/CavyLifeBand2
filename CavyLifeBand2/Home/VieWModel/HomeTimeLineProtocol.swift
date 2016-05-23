//
//  HomeTimeLineProtocol.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/25.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

protocol HomeTimeLineDataSource {
    
    var image: UIImage { get }
    var title: String { get }
    var friendName: String{ get }
    var resultNum: NSMutableAttributedString { get }
    
    
}

protocol HomeTimeLineDelegate {

    func showDetailViewController()
    
}
