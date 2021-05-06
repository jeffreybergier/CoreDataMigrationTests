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
        lock.wait()
        if let error = error { throw error }
        try self.create_v1_0_0()
    }
    
    public func fetchAll() throws -> [BasicEntity] {
        let fetch = NSFetchRequest<BasicEntity>(entityName: "BasicEntity")
        let context = self.container.viewContext
        return try context.fetch(fetch)
    }
    
    private func create_v1_0_0() throws {
        let result = try self.fetchAll()
        guard result.isEmpty else { return }
        NSLog("--- ERROR: This code should not be reached during normal testing ---")
        let context = self.container.viewContext
        let new = BasicEntity(context: context)
        new.setValue("A Known Value", forKey: "v1_0_0_name")
        try context.save()
    }
}
