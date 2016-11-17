//
//  HttpResponse.swift
//  NexmoVerify
//
//  Created by Dorian Peake on 14/05/2015.
//  Copyright (c) 2015 Nexmo. All rights reserved.
//

/** HttpResponse:
 *  Returned from a HttpRequest.execute() function call.
 *  Contains the body of a Http request.
 **/

import Foundation
/**
    Contains data returned from a HTTP request
*/
class HttpResponse {
    
    fileprivate static var Log = Logger(String(describing: HttpResponse.self))
    
    let statusCode: Int
    let body: String?
    let timestamp: String
    let headers: [AnyHashable: Any]
    
    init(statusCode: Int, body: String?, timestamp: Date, headers: [AnyHashable: Any]) {
        self.statusCode = statusCode
        self.body = body
        self.timestamp = "\(Int(timestamp.timeIntervalSince1970))"
        self.headers = headers
    }
    
    init(data: Data!, response: HTTPURLResponse, encoding: String.Encoding, timestamp: String) {
        self.timestamp = timestamp
        self.statusCode = response.statusCode
        self.headers = response.allHeaderFields
        
        if let stringData = NSString(data: data, encoding: encoding.rawValue) as? String {
            self.body = stringData
            HttpResponse.Log.info("message body = \(stringData)")
        } else  {
            body = nil
        }
    }
}
