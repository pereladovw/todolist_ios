//
//  ResponseObjectSerializable.swift
//  otodoios
//
//  Created by Ivan Zamylin on 26/06/15.
//  Copyright (c) 2015 Ivan Zamylin. All rights reserved.
//

import Foundation
import Alamofire

@objc public protocol ResponseObjectSerializable {
    init?(response: HTTPURLResponse, representation: AnyObject)
}

extension Alamofire.Request {
    public func responseObject<T: ResponseObjectSerializable>(completionHandler: (NSURLRequest, HTTPURLResponse?, T?, NSError?) -> Void) -> Self {
        let serializer: ResponseSerializer = { (request, response, data) in
            let JSONSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let (JSON: AnyObject?, serializationError) = JSONSerializer(request, response, data)
            
            if let response = response, JSON: AnyObject = JSON {
                return (T(response: response, representation: JSON), nil)
            } else {
                return (nil, serializationError)
            }
        }
        
        return response(serializer: serializer, completionHandler: { (request, response, object, error) in
            completionHandler(request, response, object as? T, error)
        })
    }
}
