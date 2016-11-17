//
//  Data+Helper.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 07/11/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation

internal extension Data {
    
    // MARK:
    // MARK: Hex
    
    /// Convert to Hex string
    internal var hexString: String {
        var tokenString = ""
        
        enumerateBytes { (buffer, _, _) in
            let formattedString = buffer.map({ String(format:"%02x", $0) }).joined()
            tokenString.append(formattedString)
        }
        
        return tokenString
    }
}
