//
//  ChartViewModel.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/29.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

protocol ChartViewProtocol {
    
    var title: String { get }
    
}

struct ChartViewModel: ChartViewProtocol {
    
    var title: String
    
    init(title: String) {
        
        self.title = title
        
    }
    
}