//
//  JSON.swift
//  Network
//
//  Created by 黄穆斌 on 16/9/22.
//  Copyright © 2016年 MuBinHuang. All rights reserved.
//

import Foundation

// MARK: - Json 数据处理

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
    
    // MARK: Methods
    
    func value(key: String, _ null: String = "") -> String {
        if let dic = json as? [String: Any] {
            if let value = dic[key] as? String {
                return value
            }
        }
        return null
    }
    
    func value<T>(key: String, _ null: T) -> T {
        if let dic = json as? [String: Any] {
            if let value = dic[key] as? T {
                return value
            }
        }
        return null
    }
}


// MARK: - Json 数据自动模型化
/**
 Json 数据对象化基类。
 使用方法:
 1. 根据 Json 内容格式建立继承自 JsonModel 的子类。
 2. 设置 JsonModel.keyValue; 该值为子对象数据类型的键值对，比如 result 字段要解析成 BClass 或 [BClass], 则需要添加 ["result": BClass] 键值对。否则将无法创建子对象。
    如果 Json 一开始返回的就是数组对象，则还需要设置 ["ArrayTypeKey": Class]
 3. 初始化最外层的 Model, 并调用其 setModel 方法。
 */
class JsonModel: NSObject {
    
    static var keyValue: [String: JsonModel.Type] = [:]
    
    required override init() {
        super.init()
    }
    
    func setModel(data: Data?) {
        if let obj = data {
            if let json = try? JSONSerialization.jsonObject(with: obj, options: JSONSerialization.ReadingOptions.allowFragments) {
                jsonKeySetValue(path: "", key: "", json: json)
            }
        }
    }
    
    private func jsonKeySetValue(path: String, key: String, json: Any) {
        if let dic = json as? [String: Any] {
            for (k, v) in dic {
                if key.isEmpty {
                    jsonKeySetValue(path: k, key: k, json: v)
                } else {
                    jsonKeySetValue(path: path + "." + k, key: k, json: v)
                }
            }
        } else if let arr = json as? [Any] {
            let typeKey = key.isEmpty ? "ArrayTypeKey" : key
            if let type = JsonModel.keyValue[typeKey] {
                var value = [JsonModel]()
                for v in arr {
                    let sub = type.init()
                    //let sub = type(of: type).init()
                    sub.jsonKeySetValue(path: "", key: "", json: v)
                    value.append(sub)
                }
                setValue(value, forKeyPath: path)
            }
        } else {
            setValue(json, forKeyPath: path)
        }
    }
    
    // MARK: Key - Value
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print("\(self) -> key: \(key) is Undefined; value: \(value);")
    }
}
