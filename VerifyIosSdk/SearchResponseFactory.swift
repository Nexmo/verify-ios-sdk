//
//  SearchResponseFactory.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 08/09/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import Foundation

class SearchResponseFactory : ResponseFactory {
    func createResponse(httpResponse: HttpResponse) -> BaseResponse? {
        return SearchResponse(httpResponse)
    }
}