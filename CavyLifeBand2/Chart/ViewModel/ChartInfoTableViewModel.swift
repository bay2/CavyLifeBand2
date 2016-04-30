//
//  ChartInfoTableViewModel.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/29.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

protocol ChartInfoTbleProtocol {
    
    var tableView: UITableView { get }
    
    
}

//struct ChartInfoTableViewModel: ChartInfoTbleProtocol, UITableViewDataSource, UITableViewDelegate {
//    
//    
//    var tableView: UITableView
//    
//  
//    init(tableView: UITableView, dataArray: Array<AnyObject>) {
//        
//        
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.separatorStyle = .None
//        tableView.scrollEnabled = false
//        tableView.registerNib(UINib(nibName: "ChartInfoListCell", bundle: nil), forCellReuseIdentifier: "ChartInfoListCell")
//        tableView.registerNib(UINib(nibName: "ChartSleepInfoCell", bundle: nil), forCellReuseIdentifier: "ChartSleepInfoCell")
//
//        self.tableView = tableView
//
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        let dataStepAttay: [String] = [L10n.ChartStepTodayStep.string, L10n.ChartStepKilometer.string, L10n.ChartTargetPercent.string, L10n.ChartStepTimeUsed.string]
//        let dataSleepAttay: [String] = [L10n.ChartSleepIndexNumber.string, L10n.ChartSleepDegreeDeep.string + L10n.ChartSleep.string, L10n.ChartSleepDegreeLight.string + L10n.ChartSleep.string, L10n.ChartTargetPercent.string]
//        
//        let cell = tableView.dequeueReusableCellWithIdentifier("ChartInfoListCell", forIndexPath: indexPath) as! ChartInfoListCell
//        
//        cell.leftLabel.text = dataStepAttay[indexPath.row]
//        
//        return cell
//
//    }
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 4
//    }
//}
