//
//  FullScreenImageView.swift
//  CavyLifeBand2
//
//  Created by JL on 16/5/18.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import AlamofireImage

class FullScreenImageView: UIView {
    
    var imageView: UIImageView = UIImageView()
    
    let loadingView = UIActivityIndicatorView(activityIndicatorStyle: .White)
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.blackColor()
        
        imageView.frame = frame
        
        imageView.contentMode = .ScaleAspectFit
        
        loadingView.frame = frame
        
        self.addSubview(imageView)
        
        self.addSubview(loadingView)
        
        self.addTapGesture { [unowned self]  _ in
            self.removeFromSuperview()
        }
        
    }
    
    convenience init(frame: CGRect, imageUrlStr: String) {
        
        self.init(frame: frame)
        
        loadingView.startAnimating()
        
        imageView.af_setImageWithURL(NSURL(string: imageUrlStr ?? "")!, placeholderImage: nil, runImageTransitionIfCached: true) { [unowned self] _ in
            self.loadingView.stopAnimating()
        }
        
    }
    
    convenience init(frame: CGRect, image: UIImage) {
        
        self.init(frame: frame)
        
        imageView.image = image
  
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
