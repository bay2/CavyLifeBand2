//
//  CharacterQueue.swift
//  test
//
//  Created by 李宝宝 on 16/3/21.
//  Copyright © 2016年 Déesse. All rights reserved.
//

import UIKit

class CharacterQueue: NSObject {
    
    /**
     传进来所有人的 姓名的数组
     
     - parameter charArray: 姓名数组
     
     - returns: 按首字母分组的字典
     */
//     func charArrayTransformDictionary(charArray: Array<String>) -> Dictionary<String, Any> {
     func charArrayTransformDictionary(charArray: Array<String>) -> [(String, Any)] {
        
        
        var dataDic = Dictionary<String, Any>()
        var keyArray = Array<String>()
        for key in dataDic.keys {
            keyArray.append(key)
        }
        
        for var i = 0 ; i < charArray.count ; i++ {
            
            let char = firstCharactor(charArray[i])
            
            // 如果key里面没有这个分组 就直接添加
            if dataDic.keys.contains(char) {
                
                var array = dataDic[char] as! Array<String>
                array.append(charArray[i])
                // 更新字典
                dataDic[char] = array
                
            } else {
                // 添加key 和 数组
                var array = Array<String>()
                array.append(charArray[i])
                dataDic.updateValue(array, forKey: char)
                
            }
        
        }
        
//        let sortKeys = Array(dataDic.keys).sort(<)
//        print(sortKeys)
//        var sortDic = Dictionary<String, Any>()
//        for var i = 0 ; i < sortKeys.count ; i++ {
//            
//            sortDic[sortKeys[i]] = dataDic[sortKeys[i]]
//        }
//        print(sortDic)
        let result = dataDic.sort { (str1, str2) -> Bool in
           return str1.0 < str2.0
        }
                
        return result
    }
    
    
    // 返回第一个字母
    func firstCharactor(name: String) -> String{
        
        let str = CFStringCreateMutableCopy(nil, 0, name)
        
        var returnStr = String()
        
        if CFStringTransform(str, nil, kCFStringTransformToLatin, false) {
            
            if CFStringTransform(str, nil, kCFStringTransformStripDiacritics, false) {
                
                // 转换类型
                let string = String(str)
                string.capitalizedString
//                print(string)
                // 获取第一个字母
                let character = string[string.startIndex]
//                print(character)
               
                returnStr = String(character)
            }
            
        }
        
        return returnStr
    }
    
}
