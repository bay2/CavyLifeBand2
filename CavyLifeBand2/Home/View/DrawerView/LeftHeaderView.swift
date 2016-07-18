//
//  LeftHeaderView.swift
//  Pods
//
//  Created by xuemincai on 16/3/17.
//
//

import UIKit
import SnapKit
import EZSwiftExtensions

class LeftHeaderView: UIView {

    override init(frame: CGRect) {

        super.init(frame: frame)

        let lineView = UIView(frame: CGRectMake(30, 5, ez.screenWidth, 0.5))

        lineView.backgroundColor = UIColor(named: .HomeViewLeftHeaderLine)
        self.addSubview(lineView)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
