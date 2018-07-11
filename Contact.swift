//
//  Contact.swift
//  MyContacts
//
//  Created by Admin on 08.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import os.log

class Contact : NSObject, NSCoding {
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Meal, just use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        let phoneNumber = aDecoder.decodeObject(forKey: PropertyKey.phoneNumber) as? String
        
        let address = aDecoder.decodeObject(forKey: PropertyKey.address) as? String?
        
        // Must call designated initializer.
        self.init(name: name, phoneNumber: phoneNumber!, photo: photo, address: address!)
    }
    
    
    //MARK: Properties
    
    var name: String
    var phoneNumber: String
    var photo: UIImage?
    var address: String?
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("contacts")
    
    //MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let phoneNumber = "phoneNumber"
        static let photo = "photo"
        static let address = "address"
    }
    
    //MARK: Initialization
    
    init?(name: String, phoneNumber: String, photo: UIImage?, address: String?){
        
        guard !name.isEmpty else {
            return nil
        }
        
        guard !phoneNumber.isEmpty else {
            return nil
        }
        
        self.name = name
        self.phoneNumber = phoneNumber
        self.photo = photo
        self.address = address
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(phoneNumber, forKey: PropertyKey.phoneNumber)
        aCoder.encode(address, forKey: PropertyKey.address)
    }
}
