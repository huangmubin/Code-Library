//
//  ExplorerCoreData.swift
//  Explorer-CoreData
//
//  Created by 黄穆斌 on 16/9/21.
//  Copyright © 2016年 MuBinHuang. All rights reserved.
//

import Foundation
import CoreData

// MARK: - Explorer Core Data

public class ExplorerCoreData: NSManagedObject, ExplorerIndexProtocol {

    // MARK: Protocol
    
    static func explorerIndexTmpFiles(isTimeOut out: Bool) -> [String] {
        return lock.sync {
            var files = [String]()
            if let context = managedObjectContext {
                do {
                    let request = NSFetchRequest<ExplorerCoreData>(entityName: entityName)
                    request.predicate = NSPredicate(format: "explorer_time < %f", out ? Date().timeIntervalSince1970 : ExplorerTime.forever.rawValue)
                    var result = try context.fetch(request)
                    result.sort {
                        return $0.explorer_time < $1.explorer_time
                    }
                    explorerIndexDeletingPathes.removeAll(keepingCapacity: true)
                    for object in result {
                        if let folder = object.explorer_folder, let name = object.explorer_name {
                            files.append(ExplorerFile.home + folder + name)
                            explorerIndexDeletingPathes.append(object)
                        }
                    }
                } catch {
                    fatalError("Failed to fetch employees: \(error)")
                }
            }
            return files
        }
    }
    static func explorerIndexTmpFiles(delete: [Int]) {
        lock.sync {
            for (i, object) in explorerIndexDeletingPathes.enumerated() {
                if delete.contains(i) {
                    let _ = ExplorerCoreData.delete(object: object)
                }
            }
            explorerIndexDeletingPathes.removeAll()
        }
    }
    
    // MARK: Static Property
    
    static let entityName = "EntityName"
    static weak var managedObjectContext: NSManagedObjectContext?
    static var lock = DispatchQueue(label: "com.Lock.Explorer.Index.CoreData", qos: DispatchQoS.userInteractive)
    private static var explorerIndexDeletingPathes = [ExplorerCoreData]()
    
    // MARK: Common Methods
    
    class func fetch(file: ExplorerFileInfo) -> ExplorerIndexProtocol? {
        return lock.sync {
            if let context = managedObjectContext {
                do {
                    let request = NSFetchRequest<ExplorerCoreData>(entityName: entityName)
                    request.predicate = NSPredicate(format: "(explorer_name == '%@') AND (explorer_folder == '%@')", file.name, file.folder)
                    let result = try context.fetch(request)
                    return result.first
                } catch {
                    fatalError("Failed to fetch employees: \(error)")
                }
            }
            return nil
        }
    }
    
    class func fetch(exist: String) -> Bool {
        return lock.sync {
            if let context = managedObjectContext {
                do {
                    let request = NSFetchRequest<ExplorerCoreData>(entityName: entityName)
                    request.predicate = NSPredicate(format: exist)
                    let result = try context.fetch(request)
                    return result.count > 0
                } catch {
                    fatalError("Failed to fetch employees: \(error)")
                }
            }
            return false
        }
    }
    
    class func saveContext() -> Bool {
        return lock.sync {
            if let context = managedObjectContext {
                if context.hasChanges {
                    do {
                        try context.save()
                        return true
                    } catch {
                        let nserror = error as NSError
                        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                    }
                }
            }
            return false
        }
    }
    
    class func delete(object: NSManagedObject) -> Bool {
        return lock.sync {
            if let context = managedObjectContext {
                context.delete(object)
                return true
            }
            return false
        }
    }
    
    // MAKR: Property
    
    @NSManaged public var explorer_name: String?
    @NSManaged public var explorer_folder: String?
    @NSManaged public var explorer_time: Double
    
    // MARK: File Managers

    func exist() -> Bool {
        return ExplorerCoreData.lock.sync {
            if let folder = explorer_folder, let name = explorer_name {
                return Explorer.default.exist(file: ExplorerFile.home + folder + name)
            }
            return false
        }
    }
    
    func read() -> Data? {
        return ExplorerCoreData.lock.sync {
            if let folder = explorer_folder, let name = explorer_name {
                return Explorer.default.read(file: ExplorerFile.home + folder + name)
            }
            return nil
        }
    }
    
    func save(data: Data?) -> Bool {
        return ExplorerCoreData.lock.sync {
            if let folder = explorer_folder, let name = explorer_name, let data = data {
                return Explorer.default.save(data: data, to: ExplorerFile.home + folder + name)
            }
            return false
        }
    }
    
    func move(to: ExplorerFileInfo) -> Bool {
        return ExplorerCoreData.lock.sync {
            if let folder = explorer_folder, let name = explorer_name {
                if Explorer.default.move(file: ExplorerFile.home + folder + name, to: to.path) {
                    explorer_folder = to.folder
                    explorer_name   = to.name
                    return true
                }
            }
            return false
        }
    }
}
