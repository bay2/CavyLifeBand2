//
//  SecondsTableViewCell.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/12.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class SecondsTableViewCell: UITableViewCell {
    
    lazy var pickerView: AKPickerView = {
        let view = AKPickerView()
        return view
    }()
    
    var index: Int? {
        didSet
        {
            scrollByIndex(index!)
        }
    }
    
    let secondsCell = "SecondsCollectionViewCell"
    
    //timeArr
    let timeModel: PhoneReminderTimeModel = PhoneReminderTimeModel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addTimePicker()
        
        self.addSeparatorView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //添加picker
    func addTimePicker() {
        self.contentView.addSubview(pickerView)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        pickerView.snp_makeConstraints { make in
            make.centerX.equalTo(self.contentView.snp_centerX)
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.height.equalTo(60.0)
            make.width.equalTo(220.0)
        }
        
        pickerView.font = UIFont.mediumSystemFontOfSize(30.0)
        pickerView.highlightedFont = UIFont.mediumSystemFontOfSize(42.0)
        
        pickerView.textColor = UIColor(named: .GColor)
        pickerView.highlightedTextColor = UIColor(named: .EColor)
        
        pickerView.pickerViewStyle = .Flat
        pickerView.maskDisabled = false
        pickerView.reloadData()
    }
    
    //添加两条分割线
    func addSeparatorView() -> Void {
     
        let separatorView1 = UIView()
        
        let separatorView2 = UIView()
        
        separatorView1.backgroundColor = UIColor(named: .LColor)
        
        separatorView2.backgroundColor = UIColor(named: .LColor)
        
        self.contentView.addSubview(separatorView1)
        
        self.contentView.addSubview(separatorView2)
        
        separatorView1.snp_makeConstraints { make in
            make.height.equalTo(1)
            make.bottom.equalTo(self.pickerView.snp_bottom)
            make.width.equalTo(200.0)
            make.centerX.equalTo(self.contentView.snp_centerX)
        }
        
        separatorView2.snp_makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(self.pickerView.snp_top)
            make.width.equalTo(separatorView1.snp_width)
            make.centerX.equalTo(separatorView1.snp_centerX)
        }
    
    }
    
    func scrollByIndex(index: Int) -> Void {
        self.pickerView.selectItem(index)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func postScrollNotification(index: Int) -> Void {
        
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.ReminderPhoneScrollToSelect.rawValue, object: nil, userInfo: ["index": index])
        
    }
    
}

extension SecondsTableViewCell: AKPickerViewDataSource {
    
    func numberOfItemsInPickerView(pickerView: AKPickerView) -> Int {
        return timeModel.timeArr.count
    }
    
    func pickerView(pickerView: AKPickerView, titleForItem item: Int) -> String {
        return timeModel.timeArr[item]
    }

    
}

extension SecondsTableViewCell: AKPickerViewDelegate {
    
    func pickerView(pickerView: AKPickerView, didSelectItem item: Int) {
        postScrollNotification(item)
    }
    
    func pickerView(pickerView: AKPickerView, marginForItem item: Int) -> CGSize {
        return CGSizeMake(20, 10)
    }
    
}
