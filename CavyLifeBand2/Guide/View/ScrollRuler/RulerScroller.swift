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
    var beginValue = 0     // 最小值
    var endValue = 20        // 最大值
    var lineSpace = 13      // 两个Line中间的空隙
    var lineCount = 12           // 两个 Longline 中间有几个 shortLine
    
    
    enum RulerDirection {
        
        case HorizontalRuler
        case VerticalRuler
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.redColor()
        
        rulerScrollerLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rulerScrollerLayout(){
    
        /// 长竖线之间的距离
        let longLabelSpace: Int = (lineCount - 1) * lineSpace

        
        // 设置scrollView的状态
        self.contentSize = CGSizeMake(CGFloat(longLabelSpace * (endValue - beginValue + 1)) + spacingWidth25 * 24, 60)
        self.contentOffset = CGPointMake(CGFloat(longLabelSpace * (endValue - beginValue)) + spacingWidth25 * 12, 0)
        print("contentSize:----------\(contentSize)")
        /**
        添加左右空白视图 半个scrollView的长度
        */
        let stanceView = UIView(frame: CGRectMake(contentSize.width - spacingWidth25 * 12, 0, spacingWidth25 * 12, 60))
        stanceView.backgroundColor = UIColor.yellowColor()
        
        
        /// 添加长线
        for var i = beginValue ; i <= endValue * lineCount; i++ {
            
            if (i+1) % lineCount == 0 {
                /// 长线上面的Label
                let lineLabel = UILabel()
                lineLabel.frame = CGRectMake(spacingWidth25 * 12 + CGFloat(lineSpace * i) - 30 , 8, 60, 18)
                lineLabel.textAlignment = .Center
                lineLabel.textColor = UIColor(named: .GuideColor99)
                lineLabel.text = String(i / 12) + ".1"
                print(lineLabel.text)
                
                /// 长线
                let longLine = UIView()
                longLine.backgroundColor = UIColor(named: .GuideLineColor)
                longLine.frame = CGRectMake(spacingWidth25 * 12 + CGFloat(lineSpace * i) , 26, 1, 34)
                self.addSubview(longLine)
                self.addSubview(lineLabel)
                
            }else{
                /// 短线
                let shortLine = UIView()
                shortLine.backgroundColor = UIColor(named: .GuideLineColor)
                shortLine.frame = CGRectMake(spacingWidth25 * 12 + CGFloat(lineSpace * i), 40, 1, 20)
                self.addSubview(shortLine)
            }
//            longLine.frame = CGRectMake(CGFloat(longLabelSpace * i), 26, 1, 34)
//            addSubview(longLine)
//            addSubview(lineLabel)
//            print(longLine.frame)
            

//            self.addSubview(shortLine)
//            shortLine.snp_makeConstraints(closure: { (make) -> Void in
//                make.size.equalTo(CGSizeMake(10, 20))
//                make.bottom.equalTo(self)
//                make.left.equalTo(self).offset(lineSpace * i)
//            })
            
            
            
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
