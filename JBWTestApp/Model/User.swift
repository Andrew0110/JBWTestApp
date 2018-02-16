//
//  User.swift
//  JBWTestApp
//
//  Created by Andrew on 15.02.18.
//  Copyright © 2018 AR. All rights reserved.
//

import Foundation

struct User {
    let uid : Int
    var name : String
    var email : String
    var accessToken : String
    var role : Int
    var status : Int
    var createdAt: Int
    var updatedAt: Int
    
    init?(_ dictionary:[String:Any]) {
        if let uid = dictionary["uid"] as? Int {
            self.uid = uid
        } else {
            return nil
        }
        self.name = dictionary["name"] as! String
        self.email = dictionary["email"] as! String
        self.accessToken = dictionary["access_token"] as! String
        self.role = dictionary["role"] as! Int
        self.status = dictionary["status"] as! Int
        self.createdAt = dictionary["created_at"] as! Int
        self.updatedAt = dictionary["updated_at"] as! Int
    }
}
