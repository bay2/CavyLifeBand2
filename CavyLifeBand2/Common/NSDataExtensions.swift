//
//  NSData.swift
//  Pods
//
//  Created by Tanner Nelson on 9/15/15.
//
//

import Foundation
import CryptoSwift

extension NSData {
    
    var uint8: UInt8 {
        get {
            var number: UInt8 = 0
            self.getBytes(&number, length: sizeof(UInt8))
            return number
        }
    }
    
    var uint16: UInt16 {
        get {
            var number: UInt16 = 0
            self.getBytes(&number, length: sizeof(UInt16))
            return number
        }
    }
    
    var uint32: UInt32 {
        get {
            var number: UInt32 = 0
            self.getBytes(&number, length: sizeof(UInt32))
            return number
        }
    }
    
    var uuid: NSUUID? {
        get {
            var bytes = [UInt8](count: self.length, repeatedValue: 0)
            self.getBytes(&bytes, length: self.length * sizeof(UInt8))
            return NSUUID(UUIDBytes: bytes)
        }
    }
    
    var string: String {
        get {
            if let string = NSString(data: self, encoding: NSUTF8StringEncoding) {
                return string as String
            } else {
                return ""
            }
        }
    }
    
    var stringUsingEddystoneUrlEncoding: String {
        get {
            //constants
            let schemePrefixes = [
                "http://www.",
                "https:/www.",
                "http://",
                "https://"
            ]
            
            let urlEncodings = [
                ".com/",
                ".org/",
                ".edu/",
                ".net/",
                ".info/",
                ".biz/",
                ".gov/",
                ".com",
                ".org",
                ".edu",
                ".net",
                ".info",
                ".biz",
                ".gov"
            ]
            
            let count = self.length / sizeof(Int8)
            var rawBytes = [Int8](count: count, repeatedValue: 0)
            self.getBytes(&rawBytes, length: count * sizeof(Int8))
            
            var urlString = ""
            
            var bytes = [Int]()
            for rawByte in rawBytes {
                bytes.append(Int(rawByte))
            }
            
            for (offset, byte) in bytes.enumerate() {
                switch offset {
                case 0:
                    if byte < schemePrefixes.count {
                        urlString += schemePrefixes[byte]
                    }
                case 1...bytes.count-1:
                    if byte < urlEncodings.count {
                        if byte < urlEncodings.count {
                            urlString += urlEncodings[byte]
                        } else {
                            urlString += String(byte)
                        }
                    } else {
                        let unicode = UnicodeScalar(byte)
                        let character = Character(unicode)
                        urlString.append(character)
                    }
                default:
                    break
                }
                
            }
            
            return urlString
        }
    }

    
}

extension Int {
    
    var data: NSData {
        var int = self
        return NSData(bytes: &int, length: sizeof(Int))
    }
    
}

extension UInt8 {
    
    var data: NSData {
        var int = self
        return NSData(bytes: &int, length: sizeof(UInt8))
    }
    
}

extension UInt16 {
    
    var data: NSData {
        var int = self
        return NSData(bytes: &int, length: sizeof(UInt16))
    }
    
}

extension UInt32 {
    
    var data: NSData {
        var int = self
        return NSData(bytes: &int, length: sizeof(UInt32))
    }
    
}

extension NSUUID {
    
    var data: NSData {
        var uuid = [UInt8](count: 16, repeatedValue: 0)
        self.getUUIDBytes(&uuid)
        return NSData(bytes: &uuid, length: 16)
    }
    
}

extension String {
    
    var dataUsingEddystoneUrlEncoding: NSData {
        get {
            var bytes = [UInt8]()
            
            typealias EncodingPattern = (pattern: String, encoding: UInt8)
            
            let urlSchemePrefixes: [EncodingPattern] = [
                ("https://www.", 1),
                ("http://www.", 0),
                ("https://", 3),
                ("http://", 2),
            ]
            
            let urlEncodings: [EncodingPattern] = [
                (".com/", 0),
                (".org/", 1),
                (".edu/", 2),
                (".net/", 3),
                (".info/", 4),
                (".biz/", 5),
                (".gov/", 6),
                (".com", 7),
                (".org", 8),
                (".edu", 9),
                (".net", 10),
                (".info", 11),
                (".biz", 12),
                (".gov", 13),
            ]
            
            var stringBuffer = self
            
            //Look for http://, etc and replace with encoding
            for prefix in urlSchemePrefixes {
                if stringBuffer.hasPrefix(prefix.pattern) {
                    if let range = stringBuffer.rangeOfString(prefix.pattern) {
                        bytes.append(prefix.encoding)
                        stringBuffer.removeRange(range)
                        break
                    }
                }
            }
            
            //For the rest of the string, loop through the
            while !stringBuffer.isEmpty {
                
                var foundEncoding = false
                for urlEncoding in urlEncodings {
                    if stringBuffer.hasPrefix(urlEncoding.pattern) {
                        if let range = stringBuffer.rangeOfString(urlEncoding.pattern) {
                            bytes.append(urlEncoding.encoding)
                            stringBuffer.removeRange(range)
                            
                            foundEncoding = true
                            break
                        }
                    }
                }
                
                if !foundEncoding {
                    for character in stringBuffer.unicodeScalars {
                        
                        bytes.append(UInt8(character.value))
                        stringBuffer = String(stringBuffer.characters.dropFirst())
                        break
                    }
                }
                
                
            }
    
            
            return NSData(bytes: bytes, length: bytes.count)
        }
    }
    
}

extension NSData {
    
    subscript(index: Int) -> UInt8 {
        
        let bytesArray = self.arrayOfBytes()
     
        return bytesArray[index]
        
    }
    
    subscript(subRange: Range<Int>) -> NSData? {
        
        let bytesArray = self.arrayOfBytes()
        
        if bytesArray.count < subRange.endIndex {
            return nil
        }
        
        return NSData(bytes: Array(bytesArray[subRange]))
        
    }

    func crc16Sub(imageCRC: UInt16, byte: UInt8) -> UInt16 {
        
        var crc: UInt16 = imageCRC
        let poly: UInt16 = 0x1021
        var msb = false
        
        var newByte = byte
        
        for _ in 0..<8  {
            
            if (crc & 0x8000) > 0 {
                msb = true
            } else {
                msb = false
            }
            
            crc <<= 1
            
            if (newByte & 0x80) > 0 {
                crc |= 0x0001
            }
            
            if msb {
                crc ^= poly
            }
            
            newByte <<= 1
            
        }

        crc &= 0xffff
        return crc
        
    }
    
    func crc16() -> UInt16 {
        
        var imageCRC: UInt16 = 0
        
        for data in self.arrayOfBytes() {
            imageCRC = crc16Sub(imageCRC, byte: data)
        }
        
        imageCRC = crc16Sub(imageCRC, byte: 0)
        imageCRC = crc16Sub(imageCRC, byte: 0)
        
        return imageCRC
    }
    

    
}

extension String {
    
    var data: NSData {
        if let data = self.dataUsingEncoding(NSUTF8StringEncoding) {
            return data
        } else {
            return NSData()
        }
    }
}

extension NSString {
    
    var data: NSData {
        if let data = self.dataUsingEncoding(NSUTF8StringEncoding) {
            return data
        } else {
            return NSData()
        }
    }
}
