//
//  HttpRequestBuilder.swift
//  NexmoVerify
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

    fileprivate static let Log = Logger(String(describing: HttpRequestBuilder.self))

    fileprivate var headers = [String:String]()
    fileprivate var params = [String:String]()
    fileprivate var url : URL
    fileprivate var postBody: String?
    fileprivate var isPost = false
    fileprivate var contentType = HttpRequest.ContentType.text
    fileprivate var encoding = String.Encoding.utf8
    fileprivate var urlQueryPartAllowedCharacterSet : NSMutableCharacterSet
    
    init?(_ urlString: String) {
        if let nsUrl = URL(string: urlString) {
            self.url = nsUrl
            urlQueryPartAllowedCharacterSet = (CharacterSet.urlQueryAllowed as NSCharacterSet).mutableCopy() as! NSMutableCharacterSet
            urlQueryPartAllowedCharacterSet.removeCharacters(in: "=?&+")
        } else {
            // bug in swift means must instantiate all neccessary vars before returning nil
            //self.url = URL()
            urlQueryPartAllowedCharacterSet = NSMutableCharacterSet()
            return nil
        }
    }
    
    init(_ url: URL) {
        self.url = url
        urlQueryPartAllowedCharacterSet = (CharacterSet.urlQueryAllowed as NSCharacterSet).mutableCopy() as! NSMutableCharacterSet
        urlQueryPartAllowedCharacterSet.removeCharacters(in: "=?&+")
    }
    
    func setHeaders(_ headers: [String:String]) -> HttpRequestBuilder {
        self.headers = headers
        return self
    }
    
    @discardableResult
    func setParams(_ params: [String:String]) -> HttpRequestBuilder {
        if (params.count > 0) {
            self.params = params
        }
        return self
    }
    
    func setUrl(_ url: URL) -> HttpRequestBuilder {
        self.url = url
        return self
    }
    
    func setUrl(_ urlString: String) -> HttpRequestBuilder? {
        if let newUrl = URL(string: urlString) {
            self.url = newUrl
            return self
        }
        
        return nil
    }
    
    func setPost(_ isPost: Bool) -> HttpRequestBuilder {
        self.isPost = isPost
        return self
    }
    
    func setContentType(_ contentType: HttpRequest.ContentType) -> HttpRequestBuilder {
        self.contentType = contentType
        return self
    }
    
    func setCharset(_ encoding: String.Encoding) -> HttpRequestBuilder {
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
                
                let encodedKey = key.addingPercentEncoding(withAllowedCharacters: self.urlQueryPartAllowedCharacterSet as CharacterSet)
                let encodedValue = value.addingPercentEncoding(withAllowedCharacters: self.urlQueryPartAllowedCharacterSet as CharacterSet)
                
                if encodedKey == nil || encodedValue == nil {
                    return nil
                }
                queryString += "\(encodedKey!)=\(encodedValue!)&"
            }
            queryString = queryString.substring(to: queryString.characters.index(before: queryString.endIndex))
        }
        
        let request : NSMutableURLRequest
        if !self.isPost {
            var urlString : String
            if self.url.query != nil {
                urlString = self.url.absoluteString
                if (queryString != "") {
                    urlString += "&\(queryString)"
                }
                
                if let newUrl = URL(string: urlString) {
                    request = NSMutableURLRequest(url: newUrl)
                } else {
                    return nil
                }
            } else {
                urlString = self.url.absoluteString
                if (queryString != "") {
                    urlString += "?\(queryString)"
                }
                
                if let newUrl = URL(string: urlString) {
                    request = NSMutableURLRequest(url: newUrl)
                } else {
                    return nil
                }
            }
        } else {
            request = NSMutableURLRequest(url: self.url)
            request.httpMethod = "POST"
            if self.contentType == HttpRequest.ContentType.form {
                request.httpBody = queryString.data(using: String.Encoding.utf8, allowLossyConversion: false)
            } else if let postBody = self.postBody {
                request.httpBody = postBody.data(using: String.Encoding.utf8, allowLossyConversion: false)
            }
        }
        
        // set up headers
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }

        // content-type and charset
        let charsetName = CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(self.encoding.rawValue))
        request.addValue(self.contentType.rawValue + "; charset=" + (charsetName as! String), forHTTPHeaderField: "Content-Type")
        
        return HttpRequest(request: request as URLRequest, encoding: self.encoding)
    }
}
