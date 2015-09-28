//
//  Logger.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 05/06/2015.
//  Copyright (c) 2015 Nexmo. All rights reserved.
//

import Foundation

/** 
    Provides more detailed logging.
*/
class Logger {

    enum LogLevel : String {
        case INFO = "INFO"
        case WARN = "WARN"
        case ERROR = "ERROR"
    }
    
    private let className : String
    private let dateFormat = NSDateFormatter()
    
    @objc(initWithClassName:)
    init(_ className: String) {
        self.className = className
        dateFormat.dateFormat = "yyyy-MM-dd HH-mm-ss"
    }
    
    private func log(level: LogLevel, message: String) {
        switch (level) {
            case .INFO,
                 .WARN,
                 .ERROR:
                print("\(dateFormat.stringFromDate(NSDate())) \(level.rawValue) [\(className)]  \(message)")
        }
    }
    
    /** Log an 'INFO' level debug statement */
    func info(message: String) {
        log(LogLevel.INFO, message: message)
    }
    
    /** Log a 'WARN' level debug statement */
    func warn(message: String) {
        log(LogLevel.WARN, message: message)
    }
    
    /** Log an 'ERROR' level debug statement */
    func error(message: String) {
        log(LogLevel.ERROR, message: message)
    }
}