//
//  CoreData.swift
//  CoreData
//
//  Created by 黄穆斌 on 16/9/22.
//  Copyright © 2016年 MuBinHuang. All rights reserved.
//

import Foundation
import CoreData

class CoreDataNote {
    
    // MARK: - Core Data stack
    
    static var `default` = CoreDataNote()
    var persistent: String = "CoreData_Test"
    var entity: String = "Entity"
    
    /// PersistentContainer
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataNote.default.persistent)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func insert() -> NSManagedObject {
        let data = NSEntityDescription.insertNewObject(forEntityName: entity, into: persistentContainer.viewContext)
        return data
    }
    
    /**
     NSPredicate
     基础比较：=, ==, >=, =>, <=, =<, >, <, !=, <>, BETWEEN
        NSPredicate(format: "value BETWEEN %@", [1, 10]) == NSPredicate(format: "(value >= %d) AND (value <= %d)", 1, 10)
     永远为真：TRUEPREDICATE；永远为假：FALSEPREDICATE；
     逻辑运算：AND, &&, OR, ||, NOT, !
     BEGINSWITH: 前缀
     CONTAINS: 包含
     ENDSWITH: 后缀
     LIKE: 可以使用 *(0或多个) 或 ?(1个) -> NSPredicate(format:@"SELF like[c] %@*%@", prefix, suffix)
     MATCHS: 正则表达式
     UTI-CONFORMS-TO:
     UTI-EQUALS:
     
     ANY, SOME:
     ALL:
     NONE:
     IN:
     array[index]:
     array[FIRST]:
     array[LAST]:
     array[SIZE]:
     */
    func fetched() -> [NSManagedObject] {
        let request = NSFetchRequest<NSManagedObject>(entityName: entity)
        request.predicate = NSPredicate(format: "value == %@", "name")
        request.sortDescriptors = [NSSortDescriptor(key: "value", ascending: true)]
        request.fetchLimit = 0
        request.fetchOffset = 0
        
        do {
            let result = try persistentContainer.viewContext.fetch(request)
            return result
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
        
        return []
    }
    
}

extension CoreDataNote {
    // MARK: Old Create CoreData Stack Methods 
    /*
    var managedObjectContext: NSManagedObjectContext
    var psc: NSPersistentStoreCoordinator
    
    override init() {
        guard let modelURL = Bundle.main.url(forResource: "CoreData_Test", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = psc
        self.psc = psc
        
        
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let docURL = urls[urls.endIndex-1]
            let storeURL = docURL.appendingPathComponent("DataModel.sqlite")
            do {
                try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
            } catch {
                fatalError("Error migrating store: \(error)")
            }
        }
    }
    */
    
}
