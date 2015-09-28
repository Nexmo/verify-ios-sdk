//
//  HttpRequest.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 13/05/2015.
//  Copyright (c) 2015 Nexmo. All rights reserved.
//

import Foundation

/**
    Performs HTTP requests. Needs to be constructed by the HttpRequestBuilder class
*/
class HttpRequest {

    enum ContentType : String {
        case HTML = "text/html"
        case JSON = "application/json"
        case XML = "application/xml"
        case TEXT = "text/plain"
        case FORM = "application/x-www-form-urlencoded"
    }
    
    private static let Log = Logger(String(HttpRequest))
    
    private let request : NSURLRequest
    private let encoding : NSStringEncoding
    private let dateFormat : NSDateFormatter
    var url : NSURL {
        get {
            return request.URL!
        }
    }
    
    init(request: NSURLRequest, encoding: NSStringEncoding) {
        self.request = request
        self.encoding = encoding
        dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "yyyy.MM.dd'T'HH:mm:ssXX"
    }
    
    /**
        Execute the current HttpRequest
        
        - parameter completionHandler: Callback containing either the HttpResponse or an NSError object upon failure.
        Only one of these parameters will be nil at a time.
    */
    func execute(completionHandler: (HttpResponse?, NSError?) -> Void) {
        HttpRequest.Log.info("executing http request...")
        let task = NSURLSession.sharedSession().dataTaskWithRequest(self.request) { (data, response, error) in
            HttpRequest.Log.info("http request completed..")
            if let error = error {
                HttpRequest.Log.error("failed with error: \(error.localizedDescription)")
                completionHandler(nil, error)
                return
            }
            // pass the response data directly to the HttpResponse class
            let httpResponse = HttpResponse(data: data, response: response as! NSHTTPURLResponse, encoding: self.encoding, timestamp: self.dateFormat.stringFromDate(NSDate()))
            HttpRequest.Log.info("attempting to call httpresponse completion handler")
            completionHandler(httpResponse, nil)
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)) {
            task.resume()
        }
        
    }
}