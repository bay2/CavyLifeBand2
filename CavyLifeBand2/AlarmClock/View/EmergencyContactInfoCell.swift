//
//  EmergencyContactInfoCell.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/29.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import RealmSwift

class EmergencyContactInfoCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    var index: NSIndexPath?
    
//    var viewModel: EmergencyContactInfoDataSource?
    weak var delegate: EmergencyContactInfoDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .None
        
        self.nameLabel.textColor = UIColor(named: .EmergencyContactCellInfoLabelColor)
        self.phoneNumberLabel.textColor = UIColor(named: .EmergencyContactCellInfoLabelColor)
        self.cancelBtn.setTitleColor(UIColor(named: .EmergencyContactCellCancelBtnTitleColor), forState: .Normal)
        
        self.nameLabel.font = UIFont.systemFontOfSize(16.0)
        self.phoneNumberLabel.font = UIFont.systemFontOfSize(12.0)
        
        self.cancelBtn.setTitle(L10n.SettingSafetyTableEmergencyContactCancelBtn.string, forState: .Normal)
        
    }
    
    func configure(dataSource: EmergencyContactInfoDataSource, delegate: EmergencyContactInfoDelegate, indexPath: NSIndexPath) -> Void {
        self.delegate = delegate
        
        self.nameLabel.text = dataSource.name
        self.phoneNumberLabel.text = dataSource.phoneNumber
        
        self.index = indexPath
    }

    override func setSelected(selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func deleteEmergencyContact(sender: UIButton) {
        self.delegate?.cancelEmergencyContact(self.index!)
    }
    
}

protocol EmergencyContactInfoDataSource {
    var name: String { get }
    var phoneNumber: String { get }
}

@objc protocol EmergencyContactInfoDelegate {
    func cancelEmergencyContact(index: NSIndexPath) -> Void
}

struct EmergencyContactInfoCellViewModel: EmergencyContactInfoDataSource {
    
    var name: String
    var phoneNumber: String
    
    init(name: String, phone: String){
        
        self.name = name
        self.phoneNumber = phone
        
    }
    
}

