//
//  RightViewController.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/4/21.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions


class RightViewController: UIViewController {
    
    @IBOutlet weak var menuTabelView: UITableView!
    var menuGroup: [MenuGroupDataSource] = []
    @IBOutlet weak var bandElectricView: BandElectricView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTableView()
        
        addMenumenuGroupData(BandFeatureMenuGroupDataModel())
        addMenumenuGroupData(BandHardwareMenuGroupDataModel())
        addMenumenuGroupData(BindingBandMenuGroupDataModel())
        
        bandElectricView.configElectricImage(0.9)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     添加菜单组数据
     
     - parameter menuGroup:
     */
    func addMenumenuGroupData(menuGroup: MenuGroupDataSource) {
        self.menuGroup.append(menuGroup)
    }
    
    func configTableView() {
        
        menuTabelView.registerNib(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuTableViewCell")
        menuTabelView.backgroundColor = UIColor(named: .HomeViewMainColor)
        
    }
    
    

}

// MARK: - tableview 扩展
extension RightViewController {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuTableViewCell", forIndexPath: indexPath)
        guard let menuCell = cell as? MenuTableViewCell else {
            return cell
        }
        
        let cellViewModel = menuGroup[indexPath.section].items[indexPath.row]
        menuCell.configure(cellViewModel, delegate: cellViewModel)
        
        return menuCell
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return menuGroup.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuGroup[section].rowCount
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return menuGroup[section].sectionHeight
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return menuGroup[section].sectionView
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        menuGroup[indexPath.section].items[indexPath.row].onClickCell()

        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return menuGroup[indexPath.section].items[indexPath.row].cellHeight
    }

}
