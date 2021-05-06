//
//  CoreDataMigrationTests.swift
//  CoreDataMigrationTests
//
//  Created by Jeffrey Bergier on 2021/05/06.
//

import XCTest
import CoreData
import CoreDataMigration

class PlainCoreDataMigrationTests: XCTestCase {
    
    let randomStoreURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
                            .appendingPathComponent(UUID().uuidString, isDirectory: true)
    var containerType: NSPersistentContainer.Type! { PlainContainer.self }
    
    override func setUpWithError() throws {
        PlainContainer.storeURL = self.randomStoreURL
    }

    override func tearDownWithError() throws {
        PlainContainer.storeURL = nil
        try FileManager.default.removeItem(at: self.randomStoreURL)
    }

    func testLoad() throws {
        _ = try Stack(self.containerType)
    }

}

class CloudCoreDataMigrationTests: PlainCoreDataMigrationTests {
    override var containerType: NSPersistentContainer.Type { CloudContainer.self }
    override func setUpWithError() throws {
        CloudContainer.storeURL = self.randomStoreURL
    }
    override func tearDownWithError() throws {
        CloudContainer.storeURL = nil
        try FileManager.default.removeItem(at: self.randomStoreURL)
    }
}
