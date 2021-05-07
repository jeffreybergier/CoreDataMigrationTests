//
//  CoreDataMigrationTests.swift
//  CoreDataMigrationTests
//
//  Created by Jeffrey Bergier on 2021/05/06.
//

import XCTest
import CoreData
import CoreDataMigration

let MyBundle = Bundle(for: AbstractCoreDataMigrationTests.self)
let Example_v1_0_0 = MyBundle.url(forResource: "Example_v1.0.0", withExtension: ".sqlite")!
let Example_v1_1_0 = MyBundle.url(forResource: "Example_v1.1.0", withExtension: ".sqlite")!
let Example_v1_1_2 = MyBundle.url(forResource: "Example_v1.1.2", withExtension: ".sqlite")!
let Example_v1_2_0 = MyBundle.url(forResource: "Example_v1.2.0", withExtension: ".sqlite")!
let Example_v2_0_0 = MyBundle.url(forResource: "Example_v2.0.0", withExtension: ".sqlite")!

class AbstractCoreDataMigrationTests: XCTestCase {
    
    let randomStoreURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
                            .appendingPathComponent(UUID().uuidString, isDirectory: true)
    var containerType: NSPersistentContainer.Type { fatalError() }
    var exampleStoreDestination: URL { self.randomStoreURL.appendingPathComponent("Migration.sqlite") }
    
    override func setUpWithError() throws {
        (self.containerType as! Storable.Type).storeURL = self.randomStoreURL
        try FileManager.default.createDirectory(at: self.randomStoreURL,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
    }

    override func tearDownWithError() throws {
        (self.containerType as! Storable.Type).storeURL = nil
        try FileManager.default.removeItem(at: self.randomStoreURL)
    }

    func testMigraion_v1_0_0() throws {
        try FileManager.default.copyItem(at: Example_v1_0_0, to: self.exampleStoreDestination)
        let stack = try Stack(self.containerType)
        let results = try stack.fetchAll()
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results[0].value(forKey: Stack.currentDBKey) as? String, Stack.knownValue)
    }
    
    func testMigration_v1_1_0() throws {
        try FileManager.default.copyItem(at: Example_v1_1_0, to: self.exampleStoreDestination)
        let stack = try Stack(self.containerType)
        let results = try stack.fetchAll()
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results[0].value(forKey: Stack.currentDBKey) as? String, Stack.knownValue)
    }
    
    func testMigration_v1_1_2() throws {
        try FileManager.default.copyItem(at: Example_v1_1_2, to: self.exampleStoreDestination)
        let stack = try Stack(self.containerType)
        let results = try stack.fetchAll()
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results[0].value(forKey: Stack.currentDBKey) as? String, Stack.knownValue)
    }
    
    func testMigration_v1_2_0() throws {
        try FileManager.default.copyItem(at: Example_v1_2_0, to: self.exampleStoreDestination)
        let stack = try Stack(self.containerType)
        let results = try stack.fetchAll()
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results[0].value(forKey: Stack.currentDBKey) as? String, Stack.knownValue)
    }
    
    func testMigration_v2_0_0() throws {
        try FileManager.default.copyItem(at: Example_v2_0_0, to: self.exampleStoreDestination)
        let stack = try Stack(self.containerType)
        let results = try stack.fetchAll()
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results[0].value(forKey: Stack.currentDBKey) as? String, Stack.knownValue)
    }

}

class PlainCoreDataMigrationTests: AbstractCoreDataMigrationTests {
    override var containerType: NSPersistentContainer.Type { PlainContainer.self }
}

class CloudCoreDataMigrationTests: AbstractCoreDataMigrationTests {
    override var containerType: NSPersistentContainer.Type { CloudContainer.self }
}
