//
//  Json.swift
//  Json
//
//  Created by 黄穆斌 on 16/9/25.
//  Copyright © 2016年 MuBinHuang. All rights reserved.
//

import Foundation

// MARK: - Json Data

class Json {
    
    // MARK: Tmp Data
    
    var json: Any? { didSet { result = json } }
    var result: Any?
    
    // MARK: Init
    
    init(_ data: Data?) {
        if let data = data {
            if let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) {
                self.json = json
                self.result = json
            }
        }
    }
    
    init(_ json: Any) {
        self.json = json
        self.result = json
    }
    
    // MARK: Subscript
    
    subscript(keys: Any...) -> Json {
        var tmp: Any? = result
        for (i, key) in keys.enumerated() {
            if i == keys.count - 1 {
                if let data = tmp as? [String: Any], let v = key as? String {
                    result = data[v]
                    continue
                } else if let data = tmp as? [Any], let v = key as? Int {
                    if v < data.count {
                        result = data[v]
                        continue
                    }
                }
            } else {
                if let data = tmp as? [String: Any], let v = key as? String {
                    tmp = data[v]
                    continue
                } else if let data = tmp as? [Any], let v = key as? Int {
                    if v < data.count {
                        tmp = data[v]
                        continue
                    }
                }
            }
            tmp = nil
        }
        return self
    }
    
    // MARK: Types
    
    var int: Int? {
        let value = result as? Int
        result = json
        return value
    }
    
    var double: Double? {
        let value = result as? Double
        result = json
        return value
    }
    
    var string: String? {
        let value = result as? String
        result = json
        return value
    }
    
    var date: Date? {
        if let value = result as? Double {
            result = json
            return Date(timeIntervalSince1970: value)
        } else {
            result = json
            return nil
        }
    }
    
    var array: [Json] {
        if let value = result as? [AnyObject] {
            result = json
            var arr = [Json]()
            for v in value {
                arr.append(Json(v))
            }
            return arr
        }
        result = json
        return []
    }
    
    var dictionary: [String: Json] {
        if var value = result as? [String: AnyObject] {
            result = json
            for (k, v) in value {
                value[k] = Json(v)
            }
            return value as! [String: Json]
        }
        result = json
        return [:]
    }
    
    func type<T>(null: T) -> T {
        if let v = result as? T {
            result = json
            return v
        } else {
            result = json
            return null
        }
    }
    
    func date(_ format: String) -> String {
        if let value = result as? Double {
            result = json
            let form = DateFormatter()
            form.dateFormat = format
            return form.string(from: Date(timeIntervalSince1970: value))
        } else {
            result = json
            return ""
        }
    }
    
    // MARK: Methods
    
    func value(key: String, _ null: String = "") -> String {
        if let dic = result as? [String: Any] {
            if let value = dic[key] as? String {
                result = json
                return value
            }
        }
        result = json
        return null
    }
    
    func value<T>(key: String, _ null: T) -> T {
        if let dic = json as? [String: Any] {
            if let value = dic[key] as? T {
                result = json
                return value
            }
        }
        result = json
        return null
    }
}

// MARK: - Json Protocol

protocol JsonProtocol {
    
    func jsonToModel(json: Json)
    
}





/*
// MARK: - Json to Model Protocol
//
//class ddd: NSObject, JsonToModelProtocol {
//    required override init() {
//        let sel = Selector("ddd.ax")
//        sel.customMirror
//    }
//    
//    var ax: Int = 0
//}

protocol JsonToModelProtocol {
    init()
    func setValue(_ value: Any?, forKeyPath: String)
    func setValue(_ value: Any?, forUndefinedKey: String)
}

extension NSObject: JsonToModelProtocol {
    
}

extension JsonToModelProtocol {
    
    func jsonContainerClasses() -> [String: JsonToModelProtocol.Type] {
        return [:]
    }
    
    func jsonCustomName() -> [String: String] {
        return [:]
    }
    
    func jsonLostList() -> [String] {
        return []
    }
    
    func jsonGetIvar() -> [String: Ivar] {
        var result = [String: Ivar]()
        let countPoint = UnsafeMutablePointer<UInt32>.allocate(capacity: 0)
        if let ivars = class_copyIvarList(object_getClass(self), countPoint) {
            let count = Int(countPoint[0])
            for i in 0 ..< count {
                if let ivar = ivars[i] {
                    if let ivarname = ivar_getName(ivar) {
                        if let name = String.init(utf8String: ivarname) {
                            result[name] = ivar
                        }
                    }
                }
            }
        }
        return result
    }
    
    static func jsonToModel(data: Any?) -> Self? {
        if let obj = data as? Data {
            if let json = try? JSONSerialization.jsonObject(with: obj, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any] {
                if let json = json {
                    return keyValueJsonToModel(json: json)
                }
            }
        }
        if let json = data as? [String: Any] {
            return keyValueJsonToModel(json: json)
        }
        return nil
    }
    
    static func keyValueJsonToModel(json: [String: Any]) -> Self {
        let model = Self.init()
        //let ivarlist = model.jsonGetIvar()
        let classes  = model.jsonContainerClasses()
        let namedic  = model.jsonCustomName()
        let lostlist = model.jsonLostList()
        
        /// For each key value in json.
        for (key, value) in json {
            /// To check the key is it in the lost list.
            guard !lostlist.contains(key) else { continue }
            /// To check whether there is a custom name key.
            let name = namedic[key] ?? key
            /// To check values type.
            switch value {
            case is Int, is Double, is String, is [Int], is [Double], is [String]:
                model.setValue(value, forKeyPath: key)
            case is [Any]:
                if let SubType = classes[key] {
                    let array = value as! [Any]
                    
                }
            default:
                break
            }
        }
        return Self.init()
    }
}
*/
