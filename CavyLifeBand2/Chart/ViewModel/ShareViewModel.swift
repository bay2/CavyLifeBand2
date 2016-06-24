//
//  ShareViewModel.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/5/17.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

protocol ShareViewDataSource {
    
    var shareImage: UIImage { get }
    
    var type: ShareType { get }
    
}


struct ShareQQViewModel: ShareViewDataSource {
    
    var shareImage: UIImage = UIImage(asset: .ShareQQ)
    
    var type: ShareType = ShareTypeQQ

}

struct ShareWechatViewModel: ShareViewDataSource {
    
    var shareImage: UIImage = UIImage(asset: .ShareWechat) 

    var type: ShareType = ShareTypeWeixiSession

}

struct ShareWechatMomentsViewModel: ShareViewDataSource {
    
    var shareImage: UIImage = UIImage(asset: .ShareWechatmoments) 

    var type: ShareType = ShareTypeWeixiTimeline

}

struct ShareWeiboViewModel: ShareViewDataSource {
    
    var shareImage: UIImage = UIImage(asset: .ShareWeibo)

    var type: ShareType = ShareTypeSinaWeibo
    
}
