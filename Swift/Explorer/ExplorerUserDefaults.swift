//
//  ExplorerUserDefaults.swift
//  Explorer-CoreData
//
//  Created by 黄穆斌 on 16/9/21.
//  Copyright © 2016年 MuBinHuang. All rights reserved.
//

import UIKit

// MAKR: - UserDefaults

class ExplorerUserDefaultsIndex: ExplorerIndexProtocol {
    
    // MARK: Protocol
    
    static func explorerIndexTmpFiles(isTimeOut out: Bool) -> [String] {
        if out {
            return ExplorerUserDefaultsIndex.default.lock.sync {
                var result = [String]()
                let outTime = Date().timeIntervalSince1970
                ExplorerUserDefaultsIndex.default.suite.dictionaryRepresentation().forEach {
                    if let value = $0.value as? [String: Any] {
                        if let time = value["time"] as? Double {
                            if outTime > time {
                                result.append(ExplorerFile.home + $0.key)
                            }
                        }
                    }
                }
                return result
            }
        } else {
            return ExplorerUserDefaultsIndex.default.lock.sync {
                var result = [(Double, String)]()
                let outTime = ExplorerTime.forever.rawValue
                ExplorerUserDefaultsIndex.default.suite.dictionaryRepresentation().forEach {
                    if let value = $0.value as? [String: Any] {
                        if let time = value["time"] as? Double {
                            if outTime > time {
                                result.append((time, $0.key))
                            }
                        }
                    }
                }
                result.sort { return $0.0 < $1.0 }
                ExplorerUserDefaultsIndex.default.explorerIndexDeletingPathes = result.map { return $1 }
                return ExplorerUserDefaultsIndex.default.explorerIndexDeletingPathes.map({ ExplorerFile.home + $0 })
            }
        }
    }
    
    static func explorerIndexTmpFiles(delete: [Int]) {
        for (i, path) in ExplorerUserDefaultsIndex.default.explorerIndexDeletingPathes.enumerated() {
            if delete.contains(i) {
                ExplorerUserDefaultsIndex.default.suite.removeObject(forKey: path)
            }
        }
        ExplorerUserDefaultsIndex.default.explorerIndexDeletingPathes.removeAll()
        ExplorerUserDefaultsIndex.default.suite.synchronize()
    }
    
    
    // MARK: Property
    
    static let `default` = ExplorerUserDefaultsIndex()
    private var suite: UserDefaults
    private var lock: DispatchQueue
    private var explorerIndexDeletingPathes: [String] = []
    
    // MARK: Init
    
    init() {
        if let user = UserDefaults(suiteName: "Explorer_File_Index") {
            suite = user
        } else {
            UserDefaults.standard.addSuite(named: "Explorer_File_Index")
            suite = UserDefaults(suiteName: "Explorer_File_Index")!
        }
        lock = DispatchQueue(label: "com.Lock.Explorer.Index.UserDefaults", qos: DispatchQoS.userInteractive)
    }
    
    // MAKR: Convenient
    
    func image(name: String) -> UIImage? {
        return lock.sync {
            if let data = Explorer.default.read(file: ExplorerFile.image[name].path) {
                if let image = UIImage(data: data) {
                    return image
                }
            }
            return nil
        }
    }
    
    func path(file: ExplorerFileInfo) -> String? {
        return lock.sync {
            if Explorer.default.exist(file: file.path) {
                return file.path
            }
            return nil
        }
    }
    
    func url(file: ExplorerFileInfo) -> URL? {
        return lock.sync {
            if Explorer.default.exist(file: file.path) {
                return URL(fileURLWithPath: file.path)
            }
            return nil
        }
    }
    
    // MARK: Index
    
    open func change(file: ExplorerFileInfo, time: TimeInterval) -> Bool {
        return lock.sync {
            if let infos = suite.value(forKey: file.shortPath) as? [String: Any] {
                if let path = infos["path"] as? String, let folder = infos["folder"] as? String, let name = infos["file"] as? String {
                    suite.set([
                        "path": path,
                        "time": time,
                        "folder": folder,
                        "file": name
                    ], forKey: file.shortPath)
                }
            }
            return false
        }
    }
    
    // MARK: File Managers
    
    func exist(file: ExplorerFileInfo) -> Bool {
        return lock.sync {
            return Explorer.default.exist(file: file.path)
        }
    }
    
    func save(data: Data?, file: ExplorerFileInfo, time: TimeInterval = ExplorerTime.forever.rawValue) -> Bool {
        return lock.sync {
            if let data = data {
                if Explorer.default.save(data: data, to: file.path) {
                    suite.set([
                        "path": file.path,
                        "time": time,
                        "folder": file.folder,
                        "file": file.name
                    ], forKey: file.shortPath)
                }
            }
            return false
        }
    }
    
    func delete(file: ExplorerFileInfo) -> Bool {
        return lock.sync {
            if Explorer.default.delete(file: file.path) {
                suite.removeObject(forKey: file.shortPath)
                return true
            }
            return false
        }
    }
    
    func move(file: ExplorerFileInfo, to: ExplorerFileInfo) -> Bool {
        return lock.sync {
            if let infos = suite.object(forKey: file.shortPath) as? [String: Any] {
                if let time = infos["time"] as? Double {
                    if Explorer.default.move(file: file.path, to: to.path) {
                        suite.removeObject(forKey: file.shortPath)
                        suite.set([
                            "path": to.path,
                            "time": time,
                            "folder": to.folder,
                            "file": to.name
                        ], forKey: to.shortPath)
                    }
                }
            }
            return false
        }
    }
    
    func copy(file: ExplorerFileInfo, to: ExplorerFileInfo) -> Bool {
        return lock.sync {
            if let infos = suite.object(forKey: file.shortPath) as? [String: Any] {
                if let time = infos["time"] as? Double {
                    if Explorer.default.move(file: file.path, to: to.path) {
                        suite.set([
                            "path": to.path,
                            "time": time,
                            "folder": to.folder,
                            "file": to.name
                        ], forKey: to.shortPath)
                    }
                }
            }
            return false
        }
    }
}
