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
    
    fileprivate static let Log = Logger(String(describing: HttpRequest.self))
    
    fileprivate let request : URLRequest
    fileprivate let encoding : String.Encoding
    fileprivate let dateFormat : DateFormatter
    var url : URL {
        get {
            return request.url!
        }
    }
    
    init(request: URLRequest, encoding: String.Encoding) {
        self.request = request
        self.encoding = encoding
        dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy.MM.dd'T'HH:mm:ssXX"
    }
    
    /**
        Execute the current HttpRequest
        
        - parameter completionHandler: Callback containing either the HttpResponse or an NSError object upon failure.
        Only one of these parameters will be nil at a time.
    */
    func execute(_ completionHandler: @escaping (HttpResponse?, NSError?) -> Void) {
        HttpRequest.Log.info("executing http request...")
        let task = URLSession.shared.dataTask(with: self.request, completionHandler: { (data, response, error) in
            HttpRequest.Log.info("http request completed..")
            if let error = error {
                HttpRequest.Log.error("failed with error: \(error.localizedDescription)")
                completionHandler(nil, error as NSError?)
                return
            }
            // pass the response data directly to the HttpResponse class
            let httpResponse = HttpResponse(data: data, response: response as! HTTPURLResponse, encoding: self.encoding, timestamp: self.dateFormat.string(from: Date()))
            HttpRequest.Log.info("attempting to call httpresponse completion handler")
            completionHandler(httpResponse, nil)

            
        }) 
        
        DispatchQueue.global().async {
            task.resume()
        }
        
    }
}
