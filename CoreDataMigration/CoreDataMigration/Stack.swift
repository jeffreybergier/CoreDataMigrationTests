//
//  Stack.swift
//  CoreDataMigration
//
//  Created by Jeffrey Bergier on 2021/05/06.
//

import CoreData

public class Stack {
    
    public let container: NSPersistentContainer
    
    public init(_ type: NSPersistentContainer.Type) throws {
        let momURL = Bundle(for: Stack.self).url(forResource: "Model", withExtension: "momd")!
        let mom = NSManagedObjectModel(contentsOf: momURL)!
        self.container = type.init(name: "Migration", managedObjectModel: mom)
        let lock = DispatchSemaphore(value: 0)
        var error: Error?
        self.container.loadPersistentStores() { _, e in
            error = e
            lock.signal()
        }
        if let error = error { throw error }
        lock.wait()
    }
    
}
