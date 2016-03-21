//
//  CharacterQueue.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/21.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class CharacterQueue: NSObject {

    
    func charArrayTransformDictionar(charArray: Array<String>) -> Dictionary<String, String> {
        
        for var i = 0 ; i < charArray.count ; i++ {
            
            
            
            
        }
        
        
        return ["uu": "uu"]
    }
    
    
//    
//    func firstCharactor(name: String) -> String{
//        
////        var str = name
//        CFStringTransform(CFMutableString(name), <#T##range: UnsafeMutablePointer<CFRange>##UnsafeMutablePointer<CFRange>#>, <#T##transform: CFString!##CFString!#>, <#T##reverse: Bool##Bool#>)
//        
//        
//        return "A"
//    }
//    
//    //获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
//    - (NSString *)firstCharactor:(NSString *)aString
//    {
//    //转成了可变字符串
//    NSMutableString *str = [NSMutableString stringWithString:aString];
//    //先转换为带声调的拼音
//    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
//    //再转换为不带声调的拼音
//    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
//    //转化为大写拼音
//    NSString *pinYin = [str capitalizedString];
//    //获取并返回首字母
//    return [pinYin substringToIndex:1];
//    }
//    
}
