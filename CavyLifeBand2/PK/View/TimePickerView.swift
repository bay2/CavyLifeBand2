//
//  TimePickerView.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/19.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

@objc protocol TimePickerViewDelegate: class {
    optional func timePickerView(timePickerView: TimePickerView, didSelectItemAtIndex index: Int) -> Void
}

class TimePickerView: UIView {
    
    static let timeCellId = "SecondsCollectionViewCell"
    
    var collectionView: UICollectionView = {
        let view: UICollectionView          = UICollectionView(frame: CGRectZero, collectionViewLayout: LineLayout())
        
        view.backgroundColor                = UIColor.whiteColor()
        
        view.showsHorizontalScrollIndicator = false
        
        view.showsVerticalScrollIndicator   = false
        
        view.registerNib(UINib.init(nibName: TimePickerView.timeCellId, bundle: nil),
                                   forCellWithReuseIdentifier: TimePickerView.timeCellId)
        
        return view
    }()
    
    lazy var timeArr: [String] = {
        return ["",
                "1",
                "2",
                "3",
                "4",
                "5",
                ""]
    }()
    
    weak var pickerDelegate: TimePickerViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override convenience init(frame: CGRect) {
        self.init(frame: frame, dataSource: nil)
    }
    
    init(frame: CGRect, dataSource: [String]?) {
        
        super.init(frame: frame)
        
        if dataSource != nil {
            timeArr = dataSource!
        }
        
        self.backgroundColor      = UIColor.whiteColor()
        
        collectionView.dataSource = self
        
        collectionView.delegate   = self
        
        self.addSubview(collectionView)
        
        collectionView.snp_makeConstraints { (make) in
            make.center.equalTo(self.snp_center)
            make.height.equalTo(self.snp_height)
            make.width.equalTo(self.snp_width)
        }
        
        addSeparatorView()
        
        Log.warning("待修改，缩放距离改变导致缩放和字体颜色和UI不符")
    }
    
    func addSeparatorView() -> Void {
        
        let separatorView1 = UIView()
        
        let separatorView2 = UIView()
        
        separatorView1.backgroundColor = UIColor(named: .PKTimePickerSeparatorColor)
        
        separatorView2.backgroundColor = UIColor(named: .PKTimePickerSeparatorColor)
        
        self.addSubview(separatorView1)
        
        self.addSubview(separatorView2)
        
        separatorView1.snp_makeConstraints { (make) in
            make.height.equalTo(1)
            make.bottom.equalTo(self.snp_top)
            make.width.equalTo(self.snp_width)
            make.centerX.equalTo(self.snp_centerX)
        }
        
        separatorView2.snp_makeConstraints { (make) in
            make.height.equalTo(1)
            make.top.equalTo(self.snp_bottom)
            make.width.equalTo(separatorView1.snp_width)
            make.centerX.equalTo(separatorView1.snp_centerX)
        }
        
    }
    
    func scrollToIndex(index: Int) -> Void {
        
        let center = self.convertPoint(collectionView.center, toView: collectionView)
        
        if let currentIndex = collectionView.indexPathForItemAtPoint(center) {
            
            if currentIndex.row != index {
                let indexPath = NSIndexPath(forItem: index, inSection: 0)
                
                collectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .CenteredHorizontally)
                
                self.collectionView(collectionView, didSelectItemAtIndexPath: indexPath)
            }
        }
    }

}

// MARK: - UICollectionViewDataSource
extension TimePickerView: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timeArr.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TimePickerView.timeCellId, forIndexPath: indexPath) as? SecondsCollectionViewCell
        
        cell!.titleLabel.text = timeArr[indexPath.row]
        
        return cell!
    }
    
}

// MARK: - UICollectionViewDelegate
extension TimePickerView: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, canFocusItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 0 || indexPath.row == timeArr.count-1 {
            return
        }
        
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: true)
        
//        Log.info("select -  \(indexPath.row)")
        
        pickerDelegate?.timePickerView?(self, didSelectItemAtIndex: indexPath.row)
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        print(scrollView.contentOffset.x)
        
        //计算当前collection视图中心的那个cell的indexPath
        let center = self.convertPoint(collectionView.center, toView: collectionView)
        
        if let indexPath = collectionView.indexPathForItemAtPoint(center) {
            
            Log.info("\(indexPath.row)")
            
            collectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .CenteredHorizontally)
            
            self.collectionView(collectionView, didSelectItemAtIndexPath: indexPath)
            
        }
        
    }

}

extension TimePickerView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(30, 40)
    }

}
