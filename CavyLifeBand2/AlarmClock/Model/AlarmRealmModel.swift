//
//  AlarmRealmModel.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/13.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import RealmSwift

class AlarmRealmModel: Object {
    
    dynamic var alarmDay = 0
    dynamic var alarmTime = "8:00"
    dynamic var isOpenAwake = true
    dynamic var isOpen = true
}
