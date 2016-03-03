//
//  RulerScroller.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/3.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit


class RulerScroller: UIScrollView {

    var currentValue = CGFloat()    // 当前值
    var beginValue = Int()      // 最小值
    var endValue = Int()        // 最大值
    var lineSpace = Int()       // 两个Line中间的空隙
    var lineCount = Int()           // 两个 Longline 中间有几个 shortLine
    
    var columeFlag = UIImageView()
    
    enum RulerDirection {
        
        case HorizontalRuler
        case VerticalRuler
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(white: 0.5, alpha: 0.2)
        
        rulerScrollerLayout()
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rulerScrollerLayout(){
    
        /**
        添加中间标志
        */
        self.addSubview(columeFlag)
        columeFlag.backgroundColor = UIColor.cyanColor()
        columeFlag.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(3, 60))
            make.centerX.equalTo(self)
            make.top.equalTo(self)
        }
        
        /**
        画刻度尺
        */
        
        let lineLabel = UILabel()
        let longLine = UILabel()
        let shortLine = UILabel()
        longLine.backgroundColor = UIColor(named: .GuideLineColor)
        shortLine.backgroundColor = UIColor(named: .GuideLineColor)
  
        for var i = beginValue ; i <= endValue; i++ {
            longLine.frame = CGRectMake(CGFloat(((lineCount - 1) * lineSpace) * i), 26, 1, 34)
//            shortLine.frame = CGRectMake(CGFloat(((lineCount - 1) * lineSpace) * i), 40, 1, 20)
            self.addSubview(longLine)
//            lineLabel.textColor = UIColor(named: .GuideColor99)
//            lineLabel.text = String(i) + ".1"
//            
//            
//            let myString: NSString = lineLabel.text! as NSString
//            let textSize: CGSize = myString.sizeWithAttributes([NSFontAttributeName: lineLabel.font])
//            if i % lineCount == 0 {
//    
//                
//            }
        }

 
        
        
    }
    
    func initRuler(lineSpace:CGFloat,middleLineNumber: Int, beginVlaue : CGFloat,endValue:CGFloat,currentValue:CGFloat) {
        
        
        
        
        
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
