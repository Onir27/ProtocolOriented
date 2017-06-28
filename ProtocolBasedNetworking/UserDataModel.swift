//
//  UserDataModel.swift
//  ProtocolBasedNetworking
//
//  Created by Nirmalya Mahanti on 27/05/17.
//  Copyright © 2017 Nirmalya Mahanti. All rights reserved.
//

import Foundation
import ObjectMapper

struct  User: Mappable,Downloadable {
    var id : Int?
    var name : String?
    var username : String?
    var email : String?
    var address : Address?
    var phone : String?
    var website : String?
    var company : Company?
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        id            <- map["id"]
        name          <- map["name"]
        username      <- map["username"]
        email         <- map["email"]
        address       <- map["address"]
        phone         <- map["phone"]
        website       <- map["website"]
        company       <- (map["company"])
    }
}

enum UserRequest {
    case getUsers
    case getUser(id: Int)
}
extension UserRequest : Request {
    var path : String {
        switch self {
        case .getUsers:
            return "users"
        case .getUser(let id):
            return "users/\(id)"
        }
    }
    var method : String { return "GET"}
    var parameters : Dictionary<String, String> { return Dictionary() }
}


struct Address: Mappable,Downloadable {
    var street : String?
    var suite : String?
    var city : String?
    var zipcode : String?
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        street          <- map["street"]
        suite           <- map["suite"]
        city            <- map["city"]
        zipcode         <- map["zipcode"]
    }
}


struct Company: Mappable,Downloadable {
    var name : String?
    var catchPhrase : String?
    var bs : String?
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        name                <- map["name"]
        catchPhrase         <- map["catchPhrase"]
        bs                  <- map["bs"]
    }
}
