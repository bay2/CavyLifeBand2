//
//  ChartInfoCollectionCell.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/28.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions
//import Charts

class ChartInfoCollectionCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {

    var viewStyle: ChartViewStyle = .StepChart
    
    var data: StepCharts?
    
    /// 柱状图
    var chartView = ShowChartsView()
    ///  列表展示信息
    var listView: UITableView?
    
    let dataCount = 4
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addChartViewLayout()
        addInfoViewLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     添加柱状图
     */
    func addChartViewLayout() {
        
        self.backgroundColor = UIColor(named: .ChartBackground)
        
        self.addSubview(chartView)
        chartView.snp_makeConstraints { make in
            make.top.equalTo(self)
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize(width: infoViewWidth, height: chartViewHight))
        }
        
//        chartView.dataArray = self.data!.charts!
        
    }
    
    /**
     添加tableView
     */
    func addInfoViewLayout() {
        
        let listBottomView = UIView()
        self.addSubview(listBottomView)
        listBottomView.snp_makeConstraints { make in
            make.top.equalTo(self).offset(chartViewHight)
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize(width: infoViewWidth, height: listViewHight))
        }
        listBottomView.backgroundColor = UIColor.whiteColor()
        
        listView = UITableView()
        listBottomView.addSubview(listView!)
        listView!.backgroundColor = UIColor.whiteColor()
        listView!.snp_makeConstraints { make in
            make.top.equalTo(listBottomView).offset(10)
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize(width: infoViewWidth, height: listViewHight - 20))
        }
        listView!.delegate = self
        listView!.dataSource = self
        listView!.separatorStyle = .None
        listView!.scrollEnabled = false
        
        listView!.registerNib(UINib(nibName: "ChartInfoListCell", bundle: nil), forCellReuseIdentifier: "ChartInfoListCell")
        listView!.registerNib(UINib(nibName: "ChartSleepInfoCell", bundle: nil), forCellReuseIdentifier: "ChartSleepInfoCell")

    }
    
    // MARK: -- UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataCount
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return listcellHight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let dataStepArray: [String] = [L10n.ChartStepTodayStep.string, L10n.ChartStepKilometer.string, L10n.ChartTargetPercent.string, L10n.ChartStepTimeUsed.string]
        let dataSleepArray: [String] = [L10n.ChartSleepIndexNumber.string, L10n.ChartSleepDegreeDeep.string + L10n.ChartSleep.string, L10n.ChartSleepDegreeLight.string + L10n.ChartSleep.string, L10n.ChartTargetPercent.string]
        
        let sleepDegree: [UIColor] = [UIColor(named: .ChartSleepDegreeLight), UIColor(named: .ChartSleepDegreeDeep)]
        
        switch viewStyle {
            
        case .SleepChart:
            
            if indexPath.row == 1 || indexPath.row == 2 {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("ChartSleepInfoCell", forIndexPath: indexPath) as! ChartSleepInfoCell
                
                cell.roundSleepView.backgroundColor = sleepDegree[indexPath.row - 1]
                cell.sleepDegree.text  = dataSleepArray[indexPath.row]
                
                return cell
                
            }
            
            let cell = tableView.dequeueReusableCellWithIdentifier("ChartInfoListCell", forIndexPath: indexPath) as! ChartInfoListCell
            
            cell.leftLabel.text = dataSleepArray[indexPath.row]
            
            return cell
            
            
        case .StepChart:
            
            let cell = tableView.dequeueReusableCellWithIdentifier("ChartInfoListCell", forIndexPath: indexPath) as! ChartInfoListCell
            
            cell.leftLabel.text = dataStepArray[indexPath.row]
            
            return cell
            

            

        }
        
        
        

    }
    
    
}
