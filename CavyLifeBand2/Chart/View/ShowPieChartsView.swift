//
//  ShowPieChartsView.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/5/6.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import Charts

class ShowPieChartsView: PieChartView, ChartViewDelegate {
    
    var chartsData: [PerStepChartData] = []
    
    var showValue: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(named: .ChartViewBackground)

        setupPieChartView()
        

        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupPieChartView() {
        
        
        self.usePercentValuesEnabled = true;
        self.drawSlicesUnderHoleEnabled = false;
        self.holeRadiusPercent = 0.58;
        self.transparentCircleRadiusPercent = 0.61;
        self.descriptionText = "";
        self.noDataTextDescription = "You need to provide data for the chart."
        self.setExtraOffsets(left: 5, top: 10, right: 5, bottom: 5)
        self.drawCenterTextEnabled = true;

        let paragraphStyle: NSMutableParagraphStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        
//        let a = NSMutableParagraphStyle.defaultParagraphStyle()
        
        paragraphStyle.lineBreakMode = .ByTruncatingTail
//        paragraphStyle.lineBreakMode =   NSLineBreakByTruncatingTail;
//        paragraphStyle.alignment = NSTextAlignmentCenter;
        

        
        
        
        /*

            
            NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
            paragraphStyle.alignment = NSTextAlignmentCenter;
            
            NSMutableAttributedString *centerText = [[NSMutableAttributedString alloc] initWithString:@"iOS Charts\nby Daniel Cohen Gindi"];
            [centerText setAttributes:@{
            NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:12.f],
            NSParagraphStyleAttributeName: paragraphStyle
            } range:NSMakeRange(0, centerText.length)];
            [centerText addAttributes:@{
            NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:10.f],
            NSForegroundColorAttributeName: UIColor.grayColor
            } range:NSMakeRange(10, centerText.length - 10)];
            [centerText addAttributes:@{
            NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:10.f],
            NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]
            } range:NSMakeRange(centerText.length - 19, 19)];
            chartView.centerAttributedText = centerText;
            
            chartView.drawHoleEnabled = YES;
            chartView.rotationAngle = 0.0;
            chartView.rotationEnabled = YES;
            chartView.highlightPerTapEnabled = YES;
            
            ChartLegend *l = chartView.legend;
            l.position = ChartLegendPositionRightOfChart;
            l.xEntrySpace = 7.0;
            l.yEntrySpace = 0.0;
            l.yOffset = 0.0;
        }*/
    }
    
    
    
    // MARK: -- ChartViewDelegate
    /**
     点击事件
     */
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        
        Log.info("\(chartView)  \(entry)   \(dataSetIndex)  \(highlight)")
        
        
        
    }
}
