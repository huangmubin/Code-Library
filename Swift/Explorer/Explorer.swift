//
//  Explorer.swift
//  Explorer
//
//  Created by 黄穆斌 on 16/9/15.
//  Copyright © 2016年 MuBinHuang. All rights reserved.
//

import Foundation

// MARK: - Explorer File Struct

struct ExplorerFileInfo {
    
    var folder: String
    var name: String
    var time: TimeInterval
    
    var shortPath: String { return folder + name }
    var path: String { return ExplorerFile.home + folder + name }
    
}

// MARK: - Explorer Time

enum ExplorerTime: TimeInterval {
    
    subscript(count: TimeInterval) -> TimeInterval {
        return rawValue * count + Date().timeIntervalSince1970
    }
    
    case hour    = 3600.0
    case day     = 86400.0
    case weak    = 604800.0
    case month   = 2592000.0
    case forever = 97830720000.0
}

// MARK: - Explorer File

enum ExplorerFile: String {

    static let home: String = "\(NSHomeDirectory())/Documents/"
    public var folder: String { return ExplorerFile.home + rawValue }
    
    subscript(file: String) -> ExplorerFileInfo {
        return ExplorerFileInfo(folder: rawValue, name: file, time: ExplorerTime.forever.rawValue)
    }
    subscript(file: String, time: TimeInterval) -> ExplorerFileInfo {
        return ExplorerFileInfo(folder: rawValue, name: file, time: time)
    }
    
    case image = "Images/"
    case video = "Videos/"
    case text  = "Texts/"
    case tmp   = "Tmps/"
}

// MARK: - Explorer File Size

enum ExplorerSize: Double {
    
    subscript(path: String) -> Double? {
        if let attributes = try? FileManager.default.attributesOfItem(atPath: path) {
            if let type = attributes[FileAttributeKey.type] as? String {
                if type != FileAttributeType.typeDirectory.rawValue {
                    if let size = attributes[FileAttributeKey.size] as? UInt {
                        return Double(size) / rawValue
                    }
                }
            }
        }
        return nil
    }
    
    case Bytes  = 1
    case KB     = 1000
    case MB     = 1000000
    case GB     = 1000000000
}

// MARK: - Explorer Index Protocol

protocol ExplorerIndexProtocol {
    static func explorerIndexTmpFiles(isTimeOut out: Bool) -> [String]
    static func explorerIndexTmpFiles(delete: [Int])
}

// MARK: - Explorer Class

class Explorer {
    
    // MAKR: Property
    
    static let `default`: Explorer = Explorer()
    static var maxTmpSpaceSize: Int = 1000000
    var indexType: ExplorerIndexProtocol.Type?
    
    // MAKR: Init
    
    private init() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationDidEnterBackground, object: nil, queue: nil) { (notification) in
            self.clearTimeOutFiles()
            self.clearTimeUnOutFiles()
        }
    }
    
    func deploy(indexType: ExplorerIndexProtocol.Type) {
        self.indexType = indexType
        
        // Clear
        clearTimeOutFiles()
        clearTimeUnOutFiles()
    }
    
    // MARK: Main Function
    
    func clearTimeOutFiles() {
        if let files = indexType?.explorerIndexTmpFiles(isTimeOut: true) {
            var error: [String] = []
            files.forEach {
                if !delete(file: $0) {
                    error.append($0)
                }
            }
            if error.count > 0 {
                print("Explorer -> deploy: Error -> can't delete files \(error)")
            }
        }
    }
    
    func clearTimeUnOutFiles() {
        if let index = indexType {
            let files = index.explorerIndexTmpFiles(isTimeOut: false)
            var total = 0
            files.forEach {
                if let size = ExplorerSize.Bytes[$0] {
                    total += Int(size)
                }
            }
            
            var deleteIndexes = [Int]()
            for (i, file) in files.enumerated() {
                if total <= Explorer.maxTmpSpaceSize {
                    break
                }
                if let size = ExplorerSize.Bytes[file] {
                    if delete(file: file) {
                        total -= Int(size)
                        deleteIndexes.append(i)
                    }
                } else {
                    deleteIndexes.append(i)
                }
            }
            
            index.explorerIndexTmpFiles(delete: deleteIndexes)
        }
    }
    
    // MAKR: - File Managers
    
    func exist(file: String) -> Bool {
        return FileManager.default.fileExists(atPath: file)
    }
    
    func read(file: String) -> Data? {
        return FileManager.default.contents(atPath: file)
    }
    
    func save(data: Data, to: String) -> Bool {
        do {
            try FileManager.default.createDirectory(at: URL(fileURLWithPath: to), withIntermediateDirectories: true, attributes: nil)
            try data.write(to: URL(fileURLWithPath: to))
            return true
        } catch { }
        return false
    }
    
    func delete(file: String) -> Bool {
        do {
            try FileManager.default.removeItem(atPath: file)
            return true
        } catch { }
        return false
    }
    
    func copy(file: String, to: String) -> Bool {
        do {
            if FileManager.default.fileExists(atPath: file) {
                try FileManager.default.createDirectory(at: URL(fileURLWithPath: file), withIntermediateDirectories: true, attributes: nil)
                try FileManager.default.copyItem(atPath: file, toPath: to)
                return true
            }
        } catch { }
        return false
    }
    
    func move(file: String, to: String) -> Bool {
        do {
            if FileManager.default.fileExists(atPath: file) {
                try FileManager.default.createDirectory(at: URL(fileURLWithPath: file), withIntermediateDirectories: true, attributes: nil)
                try FileManager.default.moveItem(atPath: file, toPath: to)
                return true
            }
        } catch { }
        return false
    }
}
