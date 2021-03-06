//
//  Stack.swift
//  CoreDataMigration
//
//  Created by Jeffrey Bergier on 2021/05/06.
//

import CoreData

public class Stack {
    
    public let container: NSPersistentContainer
    
    public static let currentDBKey = "v2_0_0_name"
    public static let knownValue = "A Known Value"
    
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
        // try self.create() // uncomment to create fake databases
    }
    
    public func fetchAll() throws -> [BasicEntity] {
        let fetch = NSFetchRequest<BasicEntity>(entityName: "BasicEntity")
        let context = self.container.viewContext
        return try context.fetch(fetch)
    }
    
    private func create() throws {
        let result = try self.fetchAll()
        guard result.isEmpty else { return }
        NSLog("--- ERROR: This code should not be reached during normal testing ---")
        let context = self.container.viewContext
        let new = BasicEntity(context: context)
        new.setValue(Stack.knownValue, forKey: Stack.currentDBKey)
        try context.save()
    }
}
