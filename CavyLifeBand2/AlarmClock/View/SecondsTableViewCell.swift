//
//  SecondsTableViewCell.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/12.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

protocol SelectPickerDelegate {
    
//    var

    func setSelectIndex(index: Int)
    
    func scrollToIndex(index: Int)
}

extension SelectPickerDelegate {

//    func setSelectIndex(index: Int) -> Void {
//        <#function body#>
//    }
//    
}

class SecondsTableViewCell: UITableViewCell {

    let collectionView: UICollectionView = {
        
        let view: UICollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 220, height: 60), collectionViewLayout: LineLayout())
        
        view.backgroundColor = UIColor.whiteColor()
        
        view.showsHorizontalScrollIndicator = false
        
        view.showsVerticalScrollIndicator = false
        
        return view
    
    }()
    
    let secondsCell = "SecondsCollectionViewCell"
    
    let secondsList = {
        return ["", "11", "12", "13", "14", "15", ""]
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        
        collectionView.dataSource = self
        
        collectionView.registerNib(UINib(nibName: secondsCell, bundle: nil), forCellWithReuseIdentifier: secondsCell)
        
        collectionView.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.contentView.snp_centerX)
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.height.equalTo(60.0)
            make.width.equalTo(220.0)
        }
        
        self.addSeparatorView()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SecondsTableViewCell.switchChangeIndex(_:)), name: NotificationName.ReminderPhoneSwitchChange.rawValue, object: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func switchChangeIndex(sender: NSNotification) -> Void {
        
        let userInfo = sender.userInfo as! [String: AnyObject]
        
        let value = userInfo["index"] as! Int
        
        Log.info("\(value)")
        
        let center = self.convertPoint(self.collectionView.center, toView: self.collectionView)
        
        if let currentIndex = self.collectionView.indexPathForItemAtPoint(center) {
            if currentIndex.row != value {
                let indexPath = NSIndexPath(forItem: value, inSection: 0)
                
                collectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .CenteredHorizontally)
                
                self.collectionView(collectionView, didSelectItemAtIndexPath: indexPath)
            }
        }
        
        
        
    }
    
    func addSeparatorView() -> Void {
     
        let separatorView1 = UIView()
        
        let separatorView2 = UIView()
        
        separatorView1.backgroundColor = UIColor(named: .SettingSeparatorColor)
        
        separatorView2.backgroundColor = UIColor(named: .SettingSeparatorColor)
        
        self.contentView.addSubview(separatorView1)
        
        self.contentView.addSubview(separatorView2)
        
        separatorView1.snp_makeConstraints { (make) in
            make.height.equalTo(1)
            make.bottom.equalTo(collectionView.snp_top)
            make.width.equalTo(200.0)
            make.centerX.equalTo(self.contentView.snp_centerX)
        }
        
        separatorView2.snp_makeConstraints { (make) in
            make.height.equalTo(1)
            make.top.equalTo(collectionView.snp_bottom)
            make.width.equalTo(separatorView1.snp_width)
            make.centerX.equalTo(separatorView1.snp_centerX)
        }
    
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: - UICollectionViewDataSource
extension SecondsTableViewCell: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return secondsList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(secondsCell, forIndexPath: indexPath) as? SecondsCollectionViewCell
        
        cell!.titleLabel.text = secondsList[indexPath.row]
        
        return cell!
    }
    
}

// MARK: - UICollectionViewDelegate
extension SecondsTableViewCell: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, canFocusItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 0 || indexPath.row == secondsList.count-1 {
            return
        }
        
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: true)
        
        Log.info("select -  \(indexPath.row)")
        
        postScrollNotification(indexPath.row)
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        print(scrollView.contentOffset.x)
        
        //计算当前collection视图中心的那个cell的indexPath
        let center = self.convertPoint(self.collectionView.center, toView: self.collectionView)
        
        if let indexPath = self.collectionView.indexPathForItemAtPoint(center) {
            
            Log.info("\(indexPath.row)")
            
            collectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .CenteredHorizontally)
            
            self.collectionView(collectionView, didSelectItemAtIndexPath: indexPath)
            
        }
        
    }
    
    func postScrollNotification(index: Int) -> Void {
        
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.ReminderPhoneScrollToSelect.rawValue, object: nil, userInfo: ["index":index])
    
    }

    
}
