//
//  Notify.swift
//  Notify
//
//  Created by 黄穆斌 on 16/9/22.
//  Copyright © 2016年 MuBinHuang. All rights reserved.
//

import Foundation

// MARK: - Notify Name

/// Notification Names
extension Notify.Name {
    /// Use in the network notifications.
    static let network: Notification.Name = Notification.Name.init("myron.notify.name.network")
    /// Use in the view operation notifications.
    static let view : Notification.Name = Notification.Name.init("myron.notify.name.view")
    /// Use in the model changed notifications.
    static let model : Notification.Name = Notification.Name.init("myron.notify.name.model")
    /// Use in other...
    static let `default`: Notification.Name = Notification.Name.init("myron.notify.name.default")
}

// MAKR: - Protocol

protocol NotifyProtocol { }
extension NotifyProtocol {
    
    /// Observer notification.
    func observer(selector: Selector, name: Notification.Name? = Notify.Name.default, object: Any? = nil) {
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: object)
    }
    /// Remove observer notification.
    func unobserver(name: Notification.Name? = nil, object: Any? = nil) {
        NotificationCenter.default.removeObserver(self, name: name, object: object)
    }
    /// Post notification.
    func post(name: Notification.Name = Notify.Name.default, userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(name: name, object: self, userInfo: userInfo)
    }
    
}

// MARK: - Notify

class Notify {
    
    struct Name { }
    
    // MARK: Property
    
    private let notification: Notification
    /// Notification name.
    var name: Notification.Name { return notification.name }
    /// Notification post objest.
    var object: Any? { return notification.object }
    
    /// userInfo[Notify.code], if nil will be -1000.
    var code: Int
    /// userInfo[Notify.code], if nil will be "Error: no message.".
    var message: String
    
    // MARK: Init
    
    init(notify: Notification) {
        self.notification = notify
        code = (self.notification.userInfo?[Notify.code] as? Int) ?? -1000
        message = (self.notification.userInfo?[Notify.message] as? String) ?? "Error: no message."
    }
    
    // MARK: Analysis Methods
    
    /// Value for notification.userInfo with key.
    subscript(key: AnyHashable) -> Any? {
        return notification.userInfo?[key]
    }
    
    /// Value for notification.userInfo with key, if nil will be null value.
    func info<T>(_ key: AnyHashable, null: T) -> T {
        if let value = notification.userInfo?[key] as? T {
            return value
        } else {
            return null
        }
    }
    
    // MARK: Class Tool Methods
    
    static let code: String = "myron.notify.userinfo.code"
    static let message: String = "myron.notify.userinfo.message"
    
    /// Create a userInfo message.
    class func info(code: Int = -1000, message: String = "Error: no message.") -> [AnyHashable: Any] {
        return [Notify.code: code, Notify.message: message]
    }
    
}
