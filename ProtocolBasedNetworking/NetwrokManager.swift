//
//  NetwrokManager.swift
//  ProtocolBasedNetworking
//
//  Created by Nirmalya Mahanti on 27/05/17.
//  Copyright © 2017 Nirmalya Mahanti. All rights reserved.
//

import Foundation
import ObjectMapper

enum MappingResult<T:Mappable> {
    case asSelf(T)
    case asDictionary([String: T])
    case asArray([T])
    case raw(Data)
}

protocol Request {
    var baseURL : String { get }
    var path : String { get }
    var method : String { get }
    var parameters : Dictionary<String, String> { get }
}
extension Request {
    var baseURL : String { return "https://jsonplaceholder.typicode.com/" }
    var path : String { return "" }
    var method : String { return "GET" }
    var parameters : Dictionary<String, String> { return Dictionary() }
    func buildRequest() -> URLRequest? {
        if let fullURL = URL(string: baseURL + path) {
            var urlRequest = URLRequest(url: fullURL)
            urlRequest.httpMethod = method
            return urlRequest
        }
        return nil
    }
}

protocol Downloadable{}

extension Downloadable where Self: Mappable {
    typealias ErrorHandler = (Error) -> Void
    typealias SuccessHandler<T> = (MappingResult<T>) -> Void where T:Mappable
    
    static func fetch(with request: Request, onSuccess: @escaping SuccessHandler<Self>, onError: @escaping ErrorHandler ){
        //1
        guard let request = request.buildRequest() else { return }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                onError(error)
            } else {
                if let data = data {
                    //2
                    var parsedArray = [Self]()
                    if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
                        //3
                        if let JSONaray = json as? [Any]
                        {
                            for object in JSONaray {
                                if let jsonObject = object as? [String:Any], let newModel = Mapper<Self>().map(JSON: jsonObject){
                                    parsedArray.append(newModel)
                                }
                            }
                        }
                        //4
                        if let JSONDictionary = json as? [String:Any] {
                            if let newModel = Mapper<Self>().map(JSON: JSONDictionary){
                                parsedArray.append(newModel)
                            }
                        }
                    }
                    //5
                    switch parsedArray.count {
                    case 1:
                        onSuccess(.asSelf(parsedArray.first!))
                    default:
                        return onSuccess(.asArray(parsedArray))
                    }
                }
            }
        }
        task.resume()
    }
}
