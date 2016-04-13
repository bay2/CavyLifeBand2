//
//  AddressBookDataSource.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/4/13.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import AddressBook
import Contacts
import EZSwiftExtensions

typealias GetPhineInfoCallBack = ((String, String, String) -> Void)

protocol AddressBookDataSource {
    
    func getAddresBookPhoneInfo(complete: GetPhineInfoCallBack?)
    
}

extension AddressBookDataSource {
    
    
    /**
     获取电话信息
     
     - parameter complete:
     */
    func getAddresBookPhoneInfo(complete: GetPhineInfoCallBack? = nil) {
        
        let contact = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
        
        if ABAddressBookGetAuthorizationStatus() == .Denied {
            Log.error("No permission address book")
            return
        }
        
        if ABAddressBookGetAuthorizationStatus() == .NotDetermined {
            
            ABAddressBookRequestAccessWithCompletion(contact) { (granted, error) in
                
                guard granted else {
                    return
                }
                
                self.readAllPeopleInAddressBook(contact, complete: complete)
            }
        }
        
        if ABAddressBookGetAuthorizationStatus() == .Authorized {
            self.readAllPeopleInAddressBook(contact, complete: complete)
        }
        
    }
    
    /**
     读取通信电话信息
     
     - parameter addressBook:
     - parameter complete:
     */
    func readAllPeopleInAddressBook(addressBook: ABAddressBook, complete: GetPhineInfoCallBack? = nil) {
        
        
        let peoples = ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue() as NSArray
        
        for people: ABRecordRef in peoples {
            
            var firstName = ""
            var lastName = ""
            
            if let firstNameUnmanaged = ABRecordCopyValue(people, kABPersonLastNameProperty) {
                firstName = firstNameUnmanaged.takeRetainedValue() as? String ?? ""
            }
            
            if let lastNameUnmanaged = ABRecordCopyValue(people, kABPersonFirstNameProperty) {
                lastName = lastNameUnmanaged.takeRetainedValue() as? String ?? ""
            }
            
            let phoneNums: ABMultiValueRef = ABRecordCopyValue(people, kABPersonPhoneProperty).takeRetainedValue()
            
            guard let phoneNumUnmanaged = ABMultiValueCopyValueAtIndex(phoneNums, 0) else {
                continue
            }
            
            var phoneNum = phoneNumUnmanaged.takeRetainedValue() as? String ?? ""
            
            phoneNum = phoneNum.stringByReplacingOccurrencesOfString("-", withString: "")
            
            complete?(firstName, lastName, phoneNum)
            
        }
        
        
    }
    
    
}