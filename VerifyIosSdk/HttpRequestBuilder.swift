//
//  HttpRequestBuilder.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 16/05/2015.
//  Copyright (c) 2015 Nexmo. All rights reserved.
//

import Foundation

/**
    Builder for HttpRequest objects.
    calling build() on a HttpRequestBuilder will return an optional HttpRequest if all the neccessary
    and provided parameters are valid.
*/
class HttpRequestBuilder {

    private static let Log = Logger(String(HttpRequestBuilder))

    private var headers = [String:String]()
    private var params = [String:String]()
    private var url : NSURL
    private var postBody: String?
    private var isPost = false
    private var contentType = HttpRequest.ContentType.TEXT
    private var encoding = NSUTF8StringEncoding
    private var urlQueryPartAllowedCharacterSet : NSMutableCharacterSet
    
    init?(_ urlString: String) {
        if let nsUrl = NSURL(string: urlString) {
            self.url = nsUrl
            urlQueryPartAllowedCharacterSet = NSCharacterSet.URLQueryAllowedCharacterSet().mutableCopy() as! NSMutableCharacterSet
            urlQueryPartAllowedCharacterSet.removeCharactersInString("=?&+")
        } else {
            // bug in swift means must instantiate all neccessary vars before returning nil
            self.url = NSURL()
            urlQueryPartAllowedCharacterSet = NSMutableCharacterSet()
            return nil
        }
    }
    
    init(_ url: NSURL) {
        self.url = url
        urlQueryPartAllowedCharacterSet = NSCharacterSet.URLQueryAllowedCharacterSet().mutableCopy() as! NSMutableCharacterSet
        urlQueryPartAllowedCharacterSet.removeCharactersInString("=?&+")
    }
    
    func setHeaders(headers: [String:String]) -> HttpRequestBuilder {
        self.headers = headers
        return self
    }
    
    func setParams(params: [String:String]) -> HttpRequestBuilder {
        if (params.count > 0) {
            self.params = params
        }
        return self
    }
    
    func setUrl(url: NSURL) -> HttpRequestBuilder {
        self.url = url
        return self
    }
    
    func setUrl(urlString: String) -> HttpRequestBuilder? {
        if let newUrl = NSURL(string: urlString) {
            self.url = newUrl
            return self
        }
        
        return nil
    }
    
    func setPost(isPost: Bool) -> HttpRequestBuilder {
        self.isPost = isPost
        return self
    }
    
    func setContentType(contentType: HttpRequest.ContentType) -> HttpRequestBuilder {
        self.contentType = contentType
        return self
    }
    
    func setCharset(encoding: NSStringEncoding) -> HttpRequestBuilder {
        self.encoding = encoding
        return self
    }
    
    /**
        Create a HttpRequest object from this builder
    */
    func build() -> HttpRequest? {
        
        var queryString = ""
        
        // create query string
        if (params.count > 0) {
            for (key, value) in params {
                
                let encodedKey = key.stringByAddingPercentEncodingWithAllowedCharacters(self.urlQueryPartAllowedCharacterSet)
                let encodedValue = value.stringByAddingPercentEncodingWithAllowedCharacters(self.urlQueryPartAllowedCharacterSet)
                
                if encodedKey == nil || encodedValue == nil {
                    HttpRequestBuilder.Log.error("Error urlencoding parameters for get request: key [ \(key) ], value [ \(value) ]")
                    return nil
                }
                queryString += "\(encodedKey!)=\(encodedValue!)&"
            }
            queryString = queryString.substringToIndex(queryString.endIndex.predecessor())
        }
        
        let request : NSMutableURLRequest
        if !self.isPost {
            var urlString : String
            if self.url.query != nil {
                urlString = self.url.absoluteString
                if (queryString != "") {
                    urlString += "&\(queryString)"
                }
                
                HttpRequestBuilder.Log.info("url = \(urlString)")
                if let newUrl = NSURL(string: urlString) {
                    request = NSMutableURLRequest(URL: newUrl)
                } else {
                    HttpRequestBuilder.Log.error("unable to construct a new url from build variables")
                    return nil
                }
            } else {
                urlString = self.url.absoluteString
                if (queryString != "") {
                    urlString += "?\(queryString)"
                }
                
                HttpRequestBuilder.Log.info(urlString)
                if let newUrl = NSURL(string: urlString) {
                    request = NSMutableURLRequest(URL: newUrl)
                } else {
                    HttpRequestBuilder.Log.error("unable to construct a new url from build variables")
                    return nil
                }
            }
        } else {
            HttpRequestBuilder.Log.info("url =\(url.absoluteString)")
            request = NSMutableURLRequest(URL: self.url)
            request.HTTPMethod = "POST"
            if self.contentType == HttpRequest.ContentType.FORM {
                request.HTTPBody = queryString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                HttpRequestBuilder.Log.info("post data = \(queryString)")
            } else if let postBody = self.postBody {
                request.HTTPBody = postBody.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                HttpRequestBuilder.Log.info("post data = \(postBody)")
            } else {
                HttpRequestBuilder.Log.warn("Warning: HTTP POST request has no post data!")
            }
        }
        
        // set up headers
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }

        // content-type and charset
        let charsetName = CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(self.encoding))
        request.addValue(self.contentType.rawValue + "; charset=" + (charsetName as String), forHTTPHeaderField: "Content-Type")
        
        return HttpRequest(request: request, encoding: self.encoding)
    }
}