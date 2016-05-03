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
    
    var viewModel: EmergencyContactInfoDataSource?
    
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
    
    func configure(model: EmergencyContactInfoDataSource) -> Void {
        self.viewModel = model
        
        self.nameLabel.text = model.name
        self.phoneNumberLabel.text = model.phoneNumber
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func deleteEmergencyContact(sender: UIButton) {
        self.viewModel?.cancelEmergencyContact()
    }
    
}

protocol EmergencyContactInfoDataSource {
    var name: String { get }
    var phoneNumber: String { get }
    func cancelEmergencyContact() -> Void
}

struct EmergencyContactInfoCellViewModel: EmergencyContactInfoDataSource, EmergencyContactRealmListOperateDelegate {
    
    var name: String
    var phoneNumber: String
    var realmModel: EmergencyContactRealmModel
    
    var realm: Realm
    var userId: String
    
    init(model: EmergencyContactRealmModel, realm: Realm){
        self.name = model.contactName
        self.phoneNumber = model.phoneNumber
        self.realmModel = model
        
        self.realm = realm
        self.userId = model.userId
    }
    
    func cancelEmergencyContact() -> Void {
        self.deleteEmergencyContactRealm(self.realmModel)
    }
    
}

