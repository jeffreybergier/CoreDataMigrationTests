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
        let stack = try Stack(self.containerType)
        let results = try stack.fetchAll()
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results[0].value(forKey: "v1_0_0_name") as? String, "A Known Value")
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
