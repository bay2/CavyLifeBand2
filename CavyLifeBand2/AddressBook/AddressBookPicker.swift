//
//  AddressBookPicker.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/5/1.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import AddressBookUI
import ContactsUI


struct SCAddressBookContact {
    
    var name: String
    var phoneList: [String]
    
}

protocol SCAddressBookPickerDelegate {
    
    func contactPicker(didSelectContact contact: SCAddressBookContact)
    
}

class SCAddressBookPicker: NSObject {
    
    var pickerDelegate: SCAddressBookPickerDelegate?
    
    func showAddressBoolPicker(viewController: UIViewController) {
        
        if #available(iOS 9.0, *) {
            
            let picker = CNContactPickerViewController()
            picker.delegate = self
            picker.displayedPropertyKeys = [CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey]
            
            viewController.presentVC(picker)
            
        } else {
            
            let picker = ABPeoplePickerNavigationController()
            picker.displayedProperties = [NSNumber(int: kABPersonFirstNameProperty), NSNumber(int: kABPersonLastNameProperty), NSNumber(int: kABPersonPhoneProperty)]
            picker.peoplePickerDelegate = self
            
            viewController.presentVC(picker)
            
        }
        
    }
    
    
}

@available(iOS 9.0, *)
extension SCAddressBookPicker: CNContactPickerDelegate {
    
    /**
     通讯录联系人选择回调
     
     - parameter picker:  选择器
     - parameter contact: 联系人信息
     */
    func contactPicker(picker: CNContactPickerViewController, didSelectContact contact: CNContact) {
        
        let phoneArr = contact.phoneNumbers
        var returnPhoneNumArr: [String] = []
       
        
        for phone in phoneArr {
            
            guard let phoneNumber = phone.value as? CNPhoneNumber else {
                return
            }
          
            returnPhoneNumArr.append(phoneNumber.stringValue)
        }
        
        let contactInfo = SCAddressBookContact(name: contact.familyName + contact.givenName, phoneList: returnPhoneNumArr.getPhoneNumArr())
        
        pickerDelegate?.contactPicker(didSelectContact: contactInfo)
        
        
    }
    
}

extension SCAddressBookPicker: ABPeoplePickerNavigationControllerDelegate {
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController, didSelectPerson person: ABRecord) {
        
        var firstName = ""
        var lastName = ""
        
        if let firstNameUnmanaged = ABRecordCopyValue(person, kABPersonLastNameProperty) {
            firstName = firstNameUnmanaged.takeRetainedValue() as? String ?? ""
        }
        
        if let lastNameUnmanaged = ABRecordCopyValue(person, kABPersonFirstNameProperty) {
            lastName = lastNameUnmanaged.takeRetainedValue() as? String ?? ""
        }
        
        var returnNumArr: [String] = []
        
        let phoneNums: ABMultiValueRef = ABRecordCopyValue(person, kABPersonPhoneProperty).takeRetainedValue()
 
        guard let phoneNumArr = ABMultiValueCopyArrayOfAllValues(phoneNums)?.takeRetainedValue()  else {
            
            CavyLifeBandAlertView.sharedIntance.showViewTitle(message: L10n.SettingSafetyPhoneNumberError.string)
            
            return
        }
        
        for i in phoneNumArr as Array {
            
            returnNumArr.append(i as? String ?? "")
        }

        let contactInfo = SCAddressBookContact(name: lastName + firstName, phoneList: returnNumArr.getPhoneNumArr())
        
        pickerDelegate?.contactPicker(didSelectContact: contactInfo)
        
    }
    
}
