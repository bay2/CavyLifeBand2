//
//  ContactsSortAndGroup.swift
//  test
//
//  Created by 李宝宝 on 16/3/21.
//  Copyright © 2016年 Déesse. All rights reserved.
//

import UIKit


class ContactsSortAndGroup: NSObject {
    
    var contactsGroupList: [(String, [ContactsListTVCellDataSource])]?

    init(contactsList: [ContactsListTVCellDataSource]) {

        super.init()
        
        self.sortAndGroup(contactsList)

    }
    
    func sortAndGroup(contactsList: [ContactsListTVCellDataSource]) {
        
        var dataDic = Dictionary<String, [ContactsListTVCellDataSource]>()
        
        for contactsInfo in contactsList {
            
            let firstChar = firstCharactor(contactsInfo.name)
            
            // 如果key里面没有这个分组 就直接添加
            if dataDic.keys.contains(firstChar) {
                
                var array = dataDic[firstChar]!
                array.append(contactsInfo)
                
                // 更新字典
                dataDic[firstChar] = array
                
            } else {
                
                // 添加key 和 数组
                var array = [ContactsListTVCellDataSource]()
                array.append(contactsInfo)
                dataDic.updateValue(array, forKey: firstChar)
                
            }
            
        }
        
        contactsGroupList = dataDic.sort { (str1, str2) -> Bool in
            return str1.0 < str2.0
        }
        
    }
    
    /**
     返回第一个字母
     
     - parameter name: 名字
     
     - returns: 第一个字母
     */
    func firstCharactor(name: String) -> String {
        
        let str = CFStringCreateMutableCopy(nil, 0, name)
        
        var returnStr = String()
        
        if CFStringTransform(str, nil, kCFStringTransformToLatin, false) {
            
            if CFStringTransform(str, nil, kCFStringTransformStripDiacritics, false) {
                
                // 转换类型
                let string = String(str)
                string.capitalizedString
                let character = string[string.startIndex]
                
                returnStr = String(character)
            }
            
        }
        
        return returnStr.uppercaseString
    }
    
}

