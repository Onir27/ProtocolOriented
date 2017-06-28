//
//  PostDataModel.swift
//  ProtocolBasedNetworking
//
//  Created by Nirmalya Mahanti on 27/05/17.
//  Copyright © 2017 Nirmalya Mahanti. All rights reserved.
//

import Foundation
import ObjectMapper

struct Post:Mappable,Downloadable {
    var userId:String?
    var id:String?
    var title:String?
    var body:String?
    
    init?(map:Map) {
        
    }
    // Mappable
    mutating func mapping(map: Map){
        userId <- map["userId"]
        id <- map["id"]
        title <- map["title"]
        body <- map["body"]
    }
}

enum PostRequest {
    case getPosts
    case getPost(id: Int)
    case getPostsBy(userId: Int)
    case newPost(title:String, body:String)
}
extension PostRequest : Request {
    var path : String {
        switch self {
        case .getPosts:
            return "posts"
        case .getPost(let id):
            return "posts/\(id)"
        case .getPostsBy(let userId):
            return "posts?userId=\(userId)"
        case .newPost:
            return "posts"
        }
    }
    var method : String {
        switch self {
        case .getPosts,.getPost,.getPostsBy:
            return "GET"
        case .newPost:
            return "POST"
        }
    }
    var parameters : Dictionary<String, String> { return Dictionary() }
}
