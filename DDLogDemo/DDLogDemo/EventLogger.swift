//
//  EventLogger.swift
//  DDLogDemo
//
//  Created by 山神 on 2019/11/6.
//  Copyright © 2019 山神. All rights reserved.
//

import UIKit
import CocoaLumberjack

class EventLogger: NSObject, DDLogFormatter {

    static let sharedInstance = EventLogger()

    override init() {
        super.init()
        fileLogger.logFormatter = self
    }

    public func setupLog() {
        DDLog.add(EventLogger.sharedInstance.fileLogger)
    }

    public func log(info: String) {
        DDLogInfo(info)
    }

    public func info(info: String) {
        DDLogInfo(info)
    }

    public func error(error: String?) {
        DDLogError(error ?? "Error is nil")
    }

    func format(message logMessage: DDLogMessage) -> String? {
        return "{" + "\"timestamp\"" + ":"  + "\"\(logMessage.timestamp)\"" + ","
            + "\"fileName\"" + ":" + "\"\(logMessage.fileName)\"" + ","
            + "\"line\"" + ":" + "\"\(String(format: "%lu", UInt(logMessage.line )))\"" + ","
            + "\"message\"" + ":" + "\"\(logMessage.message)\""  + "}"
    }

    let fileLogger: DDFileLogger = {
        let fileLogger = DDFileLogger(logFileManager: EventFileManager())
        fileLogger.rollingFrequency = 60 * 60 * 24 * 7
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        fileLogger.maximumFileSize = 2 * 1024 * 1024
        return fileLogger
    }()
}

class EventFileManager: DDLogFileManagerDefault {
    override var newLogFileName: String {
        let defaultArchiveSuffixDateFormatter = DateFormatter()
        defaultArchiveSuffixDateFormatter.locale = NSLocale.current
        defaultArchiveSuffixDateFormatter.dateFormat = "_yyyy-MM-dd_HHmmss"
        return "com.xkb.blackboard" + defaultArchiveSuffixDateFormatter.string(from: Date()) + ".log"
    }
}
